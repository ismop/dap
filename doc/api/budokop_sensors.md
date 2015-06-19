## List Budokop Sensors

Obtains a list of all Budokop Sensors present in the registry. You need to authorize yourself with a valid user account (secret token).

```
GET /budokop_sensors
```
No parameters are required

```json
{
  "budokop_sensors": [
    {
      "id": numerically unique id (e.g. 1),
      "battery_state": last reported battery level of the sensor device,
      "battery_capacity": maximum battery level of the sensor device,
      "manufacturer": manufacturer of the sensor device,
      "model": model of the sensor device,
      "serial_number": serial number of the sensor device,
      "firmware_version": version of the firmware run by the sensor device,
      "manufacture_date": specifies when the device was manufactured,
      "purchase_date": specifies when the device was purchased,
      "warranty_date": specifies the expiration date of the device's warranty period,
      "deployment_date": specifies when the device was installed,
      "last_state_change": specifies when the last state change occurred. For current state refer to the /activity_state/ attribute.
      "device_id": specifies which device the sensor belongs to
    }, {
      ...
    }
  ]
}
```

## Details of a Budokop Sensor

```
GET /budokop_sensors/:id
```

Parameters:

+ `id` (required) - The ID of the Sensor you are interested in, as returned by the GET /budokop_sensors call

```json
{
  "budokop_sensor": {
        "id": numerically unique id (e.g. 1),
         "battery_state": last reported battery level of the sensor device,
         "battery_capacity": maximum battery level of the sensor device,
         "manufacturer": manufacturer of the sensor device,
         "model": model of the sensor device,
         "serial_number": serial number of the sensor device,
         "firmware_version": version of the firmware run by the sensor device,
         "manufacture_date": specifies when the device was manufactured,
         "purchase_date": specifies when the device was purchased,
         "warranty_date": specifies the expiration date of the device's warranty period,
         "deployment_date": specifies when the device was installed,
         "last_state_change": specifies when the last state change occurred. For current state refer to the /activity_state/ attribute.
         "device_id": specifies which device the sensor belongs to
  }
}
```
