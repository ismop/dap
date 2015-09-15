## List Devices

Obtains a list of all Devices present in the registry. You need to authorize yourself with a valid user account (secret token).

```
GET /devices
```
No parameters are required, although it is possible to filter by selected attributes (equality tests only) by extending the GET request with query parameters. The response is a JSON file with the /placement/ object expressed as a GeoJSON data structure of type Point with elevation info. See http://geojson.org/geojson-spec.html for details. The 3D coordinates are given in the popular WGS 84 system, with elevation expressed as meters above (or below) sea level.

```json
{
  "devices": [
    {
        "id",
        "custom_id": external identifier of the device, specific to the levee installation setup,
        "placement": geometric coordinates of the device, expressed as a GeoJSON data structure,
        "device_type": type of the device - can be one of "neosentio-sensor", "budokop-sensor", "pump",
        "device_aggregation_id": identifier of a profile the device belongs to,
        "profile_id": identifier of the profile the device belongs to,
        "section_id": identifier of the section the device belongs to,
        "levee_id": identifier of the levee the device belongs to,
        "neosentio_sensor_id": identifier of a sensor representation of the device (if device is a neosentio sensor) or null,
        "budokop_sensor_id": identifier of a sensor representation of the device (if device is a budokop sensor) or null,
        "pump_id":  identifier of a pump representation of the device (if device is a pump) or null,
        "parameter_ids":  identifiers of parameters measured by the device,
        "metadata": a hash which contains additional metadata specific to the type of the device (i.e. its contents depend on the device_type field)
    }, {
      ...
    }
  ]
}
```

## Details of a Device

```
GET /devices/:id
```

Parameters:

+ `id` (required) - The ID of the Device you are interested in, as returned by the GET /devices call

```json
{
  "device": {
        "id",
        "custom_id": external identifier of the device, specific to the levee installation setup,
        "placement": geometric coordinates of the device, expressed as a GeoJSON data structure,
        "device_type": type of the device - can be one of "neosentio-sensor", "budokop-sensor", "pump",
        "device_aggregation_id": identifier of a profile the device belongs to,
        "profile_id": identifier of the profile the device belongs to,
        "section_id": identifier of the section the device belongs to,
        "levee_id": identifier of the levee the device belongs to,
        "neosentio_sensor_id": identifier of a sensor representation of the device (if device is a neosentio sensor) or null,
        "budokop_sensor_id": identifier of a sensor representation of the device (if device is a budokop sensor) or null,
        "pump_id":  identifier of a pump representation of the device (if device is a pump) or null,
        "parameter_ids":  identifiers of parameters measured by the device,
        "metadata": a hash which contains additional metadata specific to the type of the device (i.e. its contents depend on the device_type field)
  }
}
```
