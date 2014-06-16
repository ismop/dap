## List Levees

Get a list of all Levees being registered in the registry - which should include all Levees being monitored by
the system. You need to authorize yourself with an administrator account (a token).

```
GET /levees
```

No parameters are required. The /shape/ parameter is given in a notation called GeoJSON, that uses JSON document
to denote geographical data. More information at http://geojson.org/geojson-spec.html. Currently, we use the
MultiPoint geometric type to describe all the points in 3D space which define the shape of the Levee. The 2D
coordinates are given in the popular WGS 84 system, with longitude and latitude represented in degrees of the
spherical coordinates. The elevation, the third element of each point, is given in meter above the sea level.

```json
{
  "levees": [
    {
      "id": a numerical unique id (e.g. 1),
      "name": some human-readable name of the Levee,
      "emergency_level": one of "none", "heightened", "severe" - to be set by the human operator,
      "threat_level": one of "none", "heightened", "severe" - to be set by the Levee operations monitoring system,
      "threat_level_updated_at": a timestamp when the most recent threat_level change took place,
      "shape": the geometry of the Levee given in the GeoJSON notation
    }, {
      ...
    }
  ]
}
```


## Details of a Levee

Get the JSON document about a given Levee. You need to authorize yourself with an administrator account (a token).

```
GET /levees/:id
```

Parameters:

+ `id` (required) - The ID of the Levee you are interested in, as returned by the GET /levees call

```json
{
  "levee": {
    "id": a numerical unique id (e.g. 1),
    "name": some human-readable name of the Levee,
    "emergency_level": one of "none", "heightened", "severe" - to be set by the human operator,
    "threat_level": one of "none", "heightened", "severe" - to be set by the Levee operations monitoring system,
    "threat_level_updated_at": a timestamp when the most recent threat_level change took place,
    "shape": the geometry of the Levee given in the GeoJSON notation
  }
}
```


## Update the emergency level or the threat level for a chosen Levee

Allows to change either the emergency level or the threat level, or both, of a Levee. This represents the fact that
the operator of the Levee is willing to run more thorough monitoring of the Levee (the emergency level change) or that
the simulation output indicates the given part of a levee is at higher risk (the threat level). No other attributes
of the Levee are possible to update through this operation. The default state of both the emergency level and the
threat level, of any Levee, is 'none'. You need to authorize yourself with an administrator account (a token).

```
PUT /levees/:id
```

Parameters:

+ `id` (required) - The ID of the Levee you are interested in, as returned by the GET /levees call
+ `emergency_level` (optional) - change the current emergency_level to one of "none", "heightened", "severe"
+ `threat_level` (optional) - change the current threat_level to one of "none", "heightened", "severe"

The operation return the JSON representation of this Levee (much like the GET /levee/id operation),
with the updated field values, and a suitable error code, when some problem occurred.