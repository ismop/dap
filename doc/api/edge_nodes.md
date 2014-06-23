## List Edge Nodes

Obtains a list of all Edge Nodes present in the registry. Edge Nodes aggregate Measurement Nodes which in turn aggregate Sensors. You need to authorize yourself with a valid user account (secret token).

```
GET /edge_nodes
```
No parameters are required, although it is possible to filter by selected attributes (equality tests only) by extending the GET request with query parameters. The response is a JSON file with the /placement/ object expressed as a GeoJSON data structure of type Point without elevation info (latitude and longitude only). See http://geojson.org/geojson-spec.html for details. The 2D coordinates are given in the popular WGS 84 system.

```json
{
  "edge_nodes": [
    {
      "id": numerically unique id (e.g. 1),
      "custom_id": external identifier of the edge node, specific to the levee installation setup,
      "placement": geometric coordinates of the edge node, expressed as a GeoJSON data structure,
      "manufacturer": manufacturer of the edge node device,
      "model": model of the edge node device,
      "serial_number": serial number of the edge node device,
      "firmware_version": version of the firmware run by the edge node device,
      "manufacture_date": specifies when the device was manufactured,
      "purchase_date": specifies when the device was purchased,
      "warranty_date": specifies the expiration date of the device's warranty period,
      "deployment_date": specifies when the device was installed,
      "last_state_change": specifies when the last state change occurred. For current state refer to the /activity_state/ attribute.
      "energy_consumption": the device's energy consumption,
      "activity_state": state the device is currently in. Valid options: "aktywny", "nieaktywny", "wyłączony", "uszkodzony", "konserwacja"
      "interface_type": type of external interface provided by the device
    }, {
      ...
    }
  ]
}
```

## Details of an Edge Node

Get the JSON document about a given Edge Node. You need to authorize yourself with a valid user account (secret token).

```
GET /edge_nodes/:id
```

Parameters:

+ `id` (required) - The ID of the Edge Node you are interested in, as returned by the GET /edge_nodes call

```json
{
  "edge_node": {
    "id": numerically unique id (e.g. 1),
    "custom_id": external identifier of the edge node, specific to the levee installation setup,
    "placement": geometric coordinates of the edge node, expressed as a GeoJSON data structure,
    "manufacturer": manufacturer of the edge node device,
    "model": model of the edge node device,
    "serial_number": serial number of the edge node device,
    "firmware_version": version of the firmware run by the edge node device,
    "manufacture_date": specifies when the device was manufactured,
    "purchase_date": specifies when the device was purchased,
    "warranty_date": specifies the expiration date of the device's warranty period,
    "deployment_date": specifies when the device was installed,
    "last_state_change": specifies when the last state change occurred. For current state refer to the /activity_state/ attribute.
    "energy_consumption": the device's energy consumption,
    "activity_state": state the device is currently in. Valid options: "aktywny", "nieaktywny", "wyłączony", "uszkodzony", "konserwacja"
    "interface_type": type of external interface provided by the device
  }
}
```
