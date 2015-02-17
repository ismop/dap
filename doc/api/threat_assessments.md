## List Threat Assessments

Get a list of all threat assessments which have been defined. You need to authorize yourself with an administrator account (a token).
Each threat assessment is launched for a set of sections (see the appropriate API description) and produces results, i.e. similarity
scores for each timeline and each sensor belonging to any of the target sections.

```
GET /threat_assessment
```

No parameters are required. The /selection/ parameter is given in a notation called GeoJSON, that uses JSON document
to denote geographical data. More information at http://geojson.org/geojson-spec.html. Currently, we use the
Polygon geometric type to describe the area which has been tagged by the threat assessment's creator - any section which
contains at least one sensor falling within the target polygon will be included in the threat assessment.

```json
{
  "threat_assessments": [
    {
      "id": a numerical unique id (e.g. 1),
      "name": some human-readable name of the threat assessment,
      "selection": the geometry of the user-selected area, given in the GeoJSON notation as a Polygon object (without an inner ring).
      "start_date": beginning of the threat assessment (timestamp),
      "end_date": end of the threat assessment (timestamp),
      "status": current threat assessment status. Permitted values are: "unknown", "started", "finished", "error"
      "section_ids": identifiers of sections which are covered by this threat assessment,
      "results": all results registered for this threat assessment
    }, {
      ...
    }
  ]
}
```

## Details of a Threat Assessment

Get the JSON document about a given threat assessment. You need to authorize yourself with an administrator account (a token).

```
GET /threat_assessments/:id
```

Parameters:

+ `id` (required) - The ID of the threat assessment you are interested in, as returned by the GET /threat_assessments call

```json
{
  "threat_assessment": {
    "id": a numerical unique id (e.g. 1),
    "name": some human-readable name of the threat assessment,
    "selection": the geometry of the user-selected area, given in the GeoJSON notation as a Polygon object (without an inner ring).
    "start_date": beginning of the threat assessment (timestamp),
    "end_date": end of the threat assessment (timestamp),
    "status": current threat assessment status. Permitted values are: "unknown", "started", "finished", "error"
    "section_ids": identifiers of sections which are covered by this threat assessment,
    "results": all results registered for this threat assessment
  }
}
```
## Create a new Threat Assessment

Allows you to create a new threat assessment. You can provide a name, initial status, start date, end date and selection polygon for the threat assessment. You may also pass a list of section IDs which will be
covered by this threat assessment.

You need to authorize yourself with an administrator account (a token).

```
POST /threat_assessments/
```

Parameters:

+ `name` (optional) - some human-readable name of the threat assessment,
+ `selection` (optional) - the geometry of the user-selected area, given in the GeoJSON notation as a Polygon object (without an inner ring).
+ `start_date` (optional) - beginning of the thhreat assessment (timestamp),
+ `end_date` (optional) - end of the threat assessment (timestamp),
+ `status` (optional): current threat assessment status. Permitted values are: "unknown", "started", "finished", "error",
+ `section_ids` (optional): an array of section IDs which are covered by this threat assessment.

The operation return the JSON representation of the newly created threat assessment

## Update the details of a given Threat Assessment

Allows you to change selected details of a threat assessment - specifically, its name, status, start_date, end_date, selection and list of sections. No other attributes of the Threat Assessment can be changed through this operation. You need to authorize yourself with an administrator account (a token).

```
PUT /threat_assessments/:id
```

Parameters:

+ `id` (required) - The ID of the threat assessment you are interested in, as returned by the GET /threat_assessments call
+ `name` (optional) - some human-readable name of the threat assessment,
+ `selection` (optional) - the geometry of the user-selected area, given in the GeoJSON notation as a Polygon object (without an inner ring).
+ `start_date` (optional) - beginning of the threat assessment (timestamp),
+ `end_date` (optional) - end of the threat assessment (timestamp),
+ `status` (optional): current threat assessment status. Permitted values are: "unknown", "started", "finished", "error"
+ `section_ids` (optional): identifiers of sections which are covered by this threat assessment.

The operation return the JSON representation of this threat assessment (much like the GET /threat_assessments/id operation), with the updated field values, or a suitable error code, when a problem occurs.