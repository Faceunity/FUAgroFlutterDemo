package com.faceunity.faceunity_plugin

import android.content.Context
import android.hardware.Sensor
import android.hardware.SensorEvent
import android.hardware.SensorEventListener
import android.hardware.SensorManager
import kotlin.math.abs

/**
 *
 * @author benyq
 * @date 11/22/2023
 *
 */
class SensorHandler : SensorEventListener{

    private var _deviceOrientation = 0
    private var mSensorManager: SensorManager? = null
    private var onChangeListener: DeviceOrientationListener? = null

    fun register(context: Context, changeListener: DeviceOrientationListener) {
        mSensorManager = context.getSystemService(Context.SENSOR_SERVICE) as SensorManager
        mSensorManager?.let {
            val sensor = it.getDefaultSensor(Sensor.TYPE_ACCELEROMETER)
            it.registerListener(this, sensor, SensorManager.SENSOR_DELAY_NORMAL)
        }
        onChangeListener = changeListener
    }

    fun unregister() {
        mSensorManager?.unregisterListener(this)
        mSensorManager = null
        onChangeListener = null
    }

    override fun onSensorChanged(event: SensorEvent?) {
        event?.let {
            if (event.sensor.type == Sensor.TYPE_ACCELEROMETER) {
                val x = event.values[0]
                val y = event.values[1]
                if (abs(x) > 3 || abs(y) > 3) {
                    if (abs(x) > abs(y)) {
                        _deviceOrientation = if (x > 0) 0 else 180
                    } else {
                        _deviceOrientation = if (y > 0) 90 else 270
                    }
                    onChangeListener?.onChange(_deviceOrientation)
                }
            }
        }
    }

    override fun onAccuracyChanged(sensor: Sensor?, accuracy: Int) {
    }


    fun interface DeviceOrientationListener {
        fun onChange(deviceOrientation: Int)
    }
}