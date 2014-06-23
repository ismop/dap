## List Measurement Nodes

Obtains a list of all Measurement Nodes present in the registry. Measurement Nodes aggregate Sensors. You need to authorize yourself with a valid user account (secret token).

```
GET /measurement_nodes
```
No parameters are required, although it is possible to filter by selected attributes (equality tests only) by extending the GET request with query parameters. The response is a JSON file with the /placement/ object expressed as a GeoJSON data structure of type Point with elevation info. See http://geojson.org/geojson-spec.html for details. The 3D coordinates are given in the popular WGS 84 system, with elevation expressed as meters above (or below) sea level.

```json
{
  "measurement_nodes": [
    {
      "id": numerically unique id (e.g. 1),
      "custom_id": external identifier of the measurement node, specific to the levee installation setup,
      "placement": geometric coordinates of the measurement node, expressed as a GeoJSON data structure,
      "battery_state": last reported battery level of the measurement node device,
      "battery_capacity": maximum battery level of the measurement node device,
      "manufacturer": manufacturer of the measurement node device,
      "model": model of the measurement node device,
      "serial_number": serial number of the measurement node device,
      "firmware_version": version of the firmware run by the measurement node device,
      "manufacture_date": specifies when the device was manufactured,
      "purchase_date": specifies when the device was purchased,
      "warranty_date": specifies the expiration date of the device's warranty period,
      "deployment_date": specifies when the device was installed,
      "last_state_change": specifies when the last state change occurred. For current state refer to the /activity_state/ attribute.
      "energy_consumption": the device's energy consumption,
      "activity_state": state the device is currently in. Valid options: "aktywny", "nieaktywny", "wyłączony", "uszkodzony", "konserwacja"
      "power_type": specifies how this device is powered. Valid options: "bateryjne", "akumulatorowe", "akumulatorowe+harvesting", "sieciowe"
      "interface_type": type of external interface provided by the device
      "edge_node_id": ID of the edge node to which this device is currently connected.
    }, {
      ...
    }
  ]
}
```

## Details of a Measurement Node

Get the JSON document about a given Measurement Node. You need to authorize yourself with a valid user account (secret token).

```
GET /measurement_nodes/:id
```

Parameters:

+ `id` (required) - The ID of the Measurement Node you are interested in, as returned by the GET /measurement_nodes call

```json
{
  "measurement_node": {
      "id": numerically unique id (e.g. 1),
      "custom_id": external identifier of the measurement node, specific to the levee installation setup,
      "placement": geometric coordinates of the measurement node, expressed as a GeoJSON data structure,
      "battery_state": last reported battery level of the measurement node device,
      "battery_capacity": maximum battery level of the measurement node device,
      "manufacturer": manufacturer of the measurement node device,
      "model": model of the measurement node device,
      "serial_number": serial number of the measurement node device,
      "firmware_version": version of the firmware run by the measurement node device,
      "manufacture_date": specifies when the device was manufactured,
      "purchase_date": specifies when the device was purchased,
      "warranty_date": specifies the expiration date of the device's warranty period,
      "deployment_date": specifies when the device was installed,
      "last_state_change": specifies when the last state change occurred. For current state refer to the /activity_state/ attribute.
      "energy_consumption": the device's energy consumption,
      "activity_state": state the device is currently in. Valid options: "aktywny", "nieaktywny", "wyłączony", "uszkodzony", "konserwacja"
      "power_type": specifies how this device is powered. Valid options: "bateryjne", "akumulatorowe", "akumulatorowe+harvesting", "sieciowe"
      "interface_type": type of external interface provided by the device
      "edge_node_id": ID of the edge node to which this device is currently connected.
  }
}
```
