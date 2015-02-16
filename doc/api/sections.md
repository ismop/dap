## List sections

Get a list of all sections present in the registry or search for sections which are contained by a polygon.
You need to authorize yourself with an administrator account (a token).
Sections represent cross-sections of the embankment (levee) and aggregate sensors. Each sensor may belong to a single section. If you want to search for sections which are contained by a polygon feature, you need to pass the WKT (Well-Known Text) definition of this feature as an option in the GET request, with URL encoding applied.
The WKT definition of a polygon looks like this:

```
POLYGON ((0 0, 10 0, 10 10, 0 10, 0 0))
```

The above definition corresponds to a square-shaped feature originating at 0 deg N, 0 deg E, and with a span of 10 degrees. A properly declared polygon:

+ must have a nonzero internal area,
+ may not have a boundary which intersects itself
+ must be a closed loop (i.e. its boundary must terminate at its origin)

The polygon specification must be URL-encoded in the usual manner (see sample below). A section is assumed to be belong to the specified polygon if it includes at least one sensor which is located inside the polygon's boundary. Empty (sensorless) sections are not considered to belong to any polygon.

```
GET /sections
GET /sections?selection=POLYGON%20((0%200,%200%2010,%2010%2010,%2010%200,%200%200))
```

```json
{
  "sections": [
    {
      "id": a numerical unique id (e.g. 1),
      "shape": the geometry of the section given in the GeoJSON notation
      "sensor_ids": identifiers of sensors which belong to the target section.
    }, {
    {
     ...
    }
  ]
}
```

## Details of a section

Get the JSON representation of a given section. You need to authorize yourself with an administrator account (a token).

```
GET /sections/:id
```

Parameters:

+ `id` (required) - The ID of the section you are interested in, as returned by the GET /sections call

```json
{
  "section": {
     "id": a numerical unique id (e.g. 1),
     "shape": the geometry of the section given in the GeoJSON notation
     "sensor_ids": identifiers of sensors which belong to the target section.
  }
}
```
