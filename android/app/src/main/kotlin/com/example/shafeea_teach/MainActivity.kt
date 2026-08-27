package com.example.shafeea_teach

import android.content.Intent
import android.content.pm.PackageManager
import android.net.Uri
import androidx.core.content.FileProvider
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import java.io.File

class MainActivity: FlutterActivity() {
    private val CHANNEL = "app.shafeea/whatsapp_intent"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
            when (call.method) {
                "checkPackageInstalled" -> {
                    val packageName = call.argument<String>("packageName") ?: ""
                    result.success(isPackageInstalled(packageName))
                }
                "shareToWhatsApp" -> {
                    val packageName = call.argument<String>("packageName") ?: ""
                    val phoneNumber = call.argument<String>("phoneNumber")
                    val message = call.argument<String>("message")
                    val filePath = call.argument<String>("filePath")

                    if (!isPackageInstalled(packageName)) {
                        result.error("APP_NOT_INSTALLED", "Target application is not installed.", null)
                        return@setMethodCallHandler
                    }

                    try {
                        val intent: Intent
                        if (filePath.isNullOrBlank()) {
                            val cleanNumber = phoneNumber?.replace(Regex("[^0-9]"), "") ?: ""
                            val uriString = if (cleanNumber.isNotBlank()) {
                                "whatsapp://send?phone=$cleanNumber&text=${Uri.encode(message ?: "")}"
                            } else {
                                "whatsapp://send?text=${Uri.encode(message ?: "")}"
                            }
                            intent = Intent(Intent.ACTION_VIEW, Uri.parse(uriString))
                            intent.setPackage(packageName)
                        } else {
                            intent = Intent(Intent.ACTION_SEND)
                            val file = File(filePath)
                            val mimeType = when (file.extension.lowercase()) {
                                "pdf" -> "application/pdf"
                                "png" -> "image/png"
                                "jpg", "jpeg" -> "image/jpeg"
                                else -> "*/*"
                            }
                            intent.type = mimeType
                            intent.setPackage(packageName)

                            if (!message.isNullOrBlank()) {
                                intent.putExtra(Intent.EXTRA_TEXT, message)
                            }

                            if (!phoneNumber.isNullOrBlank()) {
                                val cleanNumber = phoneNumber.replace(Regex("[^0-9]"), "")
                                intent.putExtra("jid", "$cleanNumber@s.whatsapp.net")
                            }

                            if (file.exists()) {
                                val uri: Uri = FileProvider.getUriForFile(
                                    this, 
                                    "${this.packageName}.fileprovider", 
                                    file
                                )
                                intent.putExtra(Intent.EXTRA_STREAM, uri)
                                intent.addFlags(Intent.FLAG_GRANT_READ_URI_PERMISSION)
                            }
                        }
                        intent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
                        startActivity(intent)
                        result.success(true)
                    } catch (e: Exception) {
                        result.error("INTENT_ERROR", e.message, null)
                    }
                }
                else -> result.notImplemented()
            }
        }
    }

    private fun isPackageInstalled(packageName: String): Boolean {
        return try {
            packageManager.getPackageInfo(packageName, PackageManager.GET_ACTIVITIES)
            true
        } catch (e: PackageManager.NameNotFoundException) {
            false
        }
    }
}
