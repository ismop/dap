## List Measurements

Obtains a list of Measurements present in the registry. Each Measurement belongs to exactly one Timeline and, consequently, to exactly one Sensor. You need to authorize yourself with a valid user account (secret token).

```
GET /measurements
```
No parameters are required, although it is possible to filter by selected attributes by extending the GET request with query parameters. It is also possible to query for Measurements which fall between two arbitrarily specified dates - to do so, extend the query with /time_from/ and/or /time_to/ like so:

```
GET /measurements?time_from=2014-06-23%2015:50:40%20+0200&time_to=2014-06-23%2016:50:40%20+0200
```

This will return all measurements which fall between 23 June 2014 15:50:40 UTC+0200 and 23 June 2014 16:50:40 UTC+0200. The response is a JSON file.

Multiple (comma-separated) values can be specified in filter fields (/id/, /timeline_id/, /context_id/).

```json
{
  "measurements": [
    {
      "id": numerically unique id (e.g. 1),
      "value": the measured value. In order to determine how to interpret this value, refer to the /measurement_type_name/ and /measurement_type_unit/ properties of this measurement's sensor.
      "timestamp": the exact date and time of this measurement
      "source_address": information on this measurement's source (for future use)
      "timeline_id": ID of the timeline to which this measurement belongs
    }, {

      ...
    }
  ]
}
```

## Details of a Measurement

```
GET /measurements/:id
```

Parameters:

+ `id` (required) - The ID of the Measurement you are interested in, as returned by the GET /measurements call. Multiple (comma-separated) values can be entered.

```json
{
  "measurement": {
    "id": numerically unique id (e.g. 1),
    "value": the measured value. In order to determine how to interpret this value, refer to the /measurement_type_name/ and /measurement_type_unit/ properties of this measurement's sensor.
    "timestamp": the exact date and time of this measurement
    "source_address": information on this measurement's source (for future use)
    "timeline_id": ID of the timeline to which this measurement belongs
  }
}
```
