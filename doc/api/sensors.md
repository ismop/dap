## List Sensors

Obtains a list of all Sensors present in the registry. Each Sensor may have multiple Timelines and must belong to one Measurement Node. You need to authorize yourself with a valid user account (secret token).

```
GET /sensors
```
No parameters are required, although it is possible to filter by selected attributes (equality tests only) by extending the GET request with query parameters. The response is a JSON file with the /placement/ object expressed as a GeoJSON data structure of type Point with elevation info. See http://geojson.org/geojson-spec.html for details. The 3D coordinates are given in the popular WGS 84 system, with elevation expressed as meters above (or below) sea level.

```json
{
  "sensors": [
    {
      "id": numerically unique id (e.g. 1),
      "custom_id": external identifier of the sensor, specific to the levee installation setup,
      "placement": geometric coordinates of the sensor, expressed as a GeoJSON data structure,
      "x_orientation": The orientation (not placement!) of the sensor along the X axis.
      "y_orientation": The orientation (not placement!) of the sensor along the Y axis.
      "z_orientation": The orientation (not placement!) of the sensor along the Z axis.
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
      "energy_consumption": the device's energy consumption,
      "precision": the precision of this sensor's measurement
      "measurement_type_name": the name of the measurement which this sensor provides (e.g. "Temperatura", "Ciśnienie porowe" etc.)
      "measurement_type_unit": the unit of the measurement which this sensor provides (e.g. "Pa", "mm", "C" etc.)
      "activity_state": state the device is currently in. Valid options: "aktywny", "nieaktywny", "wyłączony", "uszkodzony", "konserwacja"
      "power_type": specifies how this device is powered. Valid options: "bateryjne", "akumulatorowe", "akumulatorowe+harvesting", "sieciowe"
      "interface_type": type of external interface provided by the device
      "measurement_node_id": ID of the measurement node to which this sensor is currently connected.
      "timeline_ids": an array with IDs of timelines which have been registered for this sensor.
    }, {
      ...
    }
  ]
}
```

## Details of a Sensor

```
GET /sensors/:id
```

Parameters:

+ `id` (required) - The ID of the Sensor you are interested in, as returned by the GET /sensors call

```json
{
  "sensor": {
      "id": numerically unique id (e.g. 1),
      "custom_id": external identifier of the sensor  specific to the levee installation setup,
      "placement": geometric coordinates of the sensor, expressed as a GeoJSON data structure,
      "x_orientation": The orientation (not placement!) of the sensor along the X axis.
      "y_orientation": The orientation (not placement!) of the sensor along the Y axis.
      "z_orientation": The orientation (not placement!) of the sensor along the Z axis.
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
      "energy_consumption": the device's energy consumption,
      "precision": the precision of this sensor's measurement
      "measurement_type_name": the name of the measurement which this sensor provides (e.g. "Temperatura", "Ciśnienie porowe" etc.)
      "measurement_type_unit": the unit of the measurement which this sensor provides (e.g. "Pa", "mm", "C" etc.)
      "activity_state": state the device is currently in. Valid options: "aktywny", "nieaktywny", "wyłączony", "uszkodzony", "konserwacja"
      "power_type": specifies how this device is powered. Valid options: "bateryjne", "akumulatorowe", "akumulatorowe+harvesting", "sieciowe"
      "interface_type": type of external interface provided by the device
      "measurement_node_id": ID of the measurement node to which this sensor is currently connected.
      "timeline_ids": an array with IDs of timelines which have been registered for this sensor.
  }
}
```
