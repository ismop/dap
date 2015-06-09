## List Neosentio Sensors

Obtains a list of all Neosentio Sensors present in the registry. You need to authorize yourself with a valid user account (secret token).

```
GET /neosentio_sensors
```
No parameters are required.

```json
{
  "neosentio_sensors": [
    {
        "id": numerically unique id (e.g. 1),
        "x_orientation": The orientation (not placement!) of the sensor along the X axis.,
        "y_orientation": The orientation (not placement!) of the sensor along the Y axis.,
        "z_orientation": The orientation (not placement!) of the sensor along the Z axis.,
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
        "energy_consumption": the device's energy consumption,,
        "precision": the precision of this sensor's measurement,
        "measurement_node_id": ID of the measurement node to which this sensor is currently connected,
        "device_id": specifies which device the sensor belongs to
        "activity_state":  state the device is currently in. Valid options: "aktywny", "nieaktywny", "wyłączony", "uszkodzony", "konserwacja",
        "power_type": specifies how this device is powered. Valid options: "bateryjne", "akumulatorowe", "akumulatorowe+harvesting", "sieciowe",
        "interface_type": type of external interface provided by the device
    }, {
      ...
    }
  ]
}
```

## Details of a Neosentio Sensor

```
GET /neosentio_sensors/:id
```

Parameters:

+ `id` (required) - The ID of the Neosentio Sensor you are interested in, as returned by the GET /neosentio_sensors call

```json
{
  "neosentio_sensor": {
        "id": numerically unique id (e.g. 1),
        "x_orientation": The orientation (not placement!) of the sensor along the X axis.,
        "y_orientation": The orientation (not placement!) of the sensor along the Y axis.,
        "z_orientation": The orientation (not placement!) of the sensor along the Z axis.,
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
        "energy_consumption": the device's energy consumption,,
        "precision": the precision of this sensor's measurement,
        "measurement_node_id": ID of the measurement node to which this sensor is currently connected,
        "device_id": specifies which device the sensor belongs to
        "activity_state":  state the device is currently in. Valid options: "aktywny", "nieaktywny", "wyłączony", "uszkodzony", "konserwacja",
        "power_type": specifies how this device is powered. Valid options: "bateryjne", "akumulatorowe", "akumulatorowe+harvesting", "sieciowe",
        "interface_type": type of external interface provided by the device
  }
}
```
