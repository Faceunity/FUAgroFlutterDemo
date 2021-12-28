package com.sven.fluttedemo

import android.Manifest
import android.os.Bundle
import io.flutter.embedding.android.FlutterActivity

class MainActivity: FlutterActivity() {

	override fun onCreate(savedInstanceState: Bundle?) {
		super.onCreate(savedInstanceState)
		if (android.os.Build.VERSION.SDK_INT >= android.os.Build.VERSION_CODES.M) {
			val permissions = arrayOf(Manifest.permission.CAMERA
					, Manifest.permission.READ_EXTERNAL_STORAGE
					, Manifest.permission.WRITE_EXTERNAL_STORAGE
					, Manifest.permission.RECORD_AUDIO)
			requestPermissions(permissions, 1)
		}
	}
}
