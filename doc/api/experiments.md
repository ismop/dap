## List threat assessments

Get a list of all threat_assessments which have been defined. You need to authorize yourself with an administrator account (a token).
Each threat_assessment is launched for a set of sections (see the appropriate API description) and produces results, i.e. similarity
scores for each timeline and each sensor belonging to any of the target sections.

```
GET /threat_assessment
```

No parameters are required. The /selection/ parameter is given in a notation called GeoJSON, that uses JSON document
to denote geographical data. More information at http://geojson.org/geojson-spec.html. Currently, we use the
Polygon geometric type to describe the area which has been tagged by the threat_assessment's creator - any section which
contains at least one sensor falling within the target polygon will be included in the threat_assessment.

```json
{
  "threat_assessments": [
    {
      "id": a numerical unique id (e.g. 1),
      "name": some human-readable name of the threat_assessment,
      "selection": the geometry of the user-selected area, given in the GeoJSON notation as a Polygon object (without an inner ring).
      "start_date": beginning of the threat_assessment (timestamp),
      "end_date": end of the threat_assessment (timestamp),
      "status": current threat_assessment status. Permitted values are: "unknown", "started", "finished", "error"
      "section_ids": identifiers of sections which are covered by this threat_assessment,
      "results": all results registered for this threat_assessment
    }, {
      ...
    }
  ]
}
```

## Details of an threat_assessment

Get the JSON document about a given threat_assessment. You need to authorize yourself with an administrator account (a token).

```
GET /threat_assessments/:id
```

Parameters:

+ `id` (required) - The ID of the threat_assessment you are interested in, as returned by the GET /threat_assessments call

```json
{
  "threat_assessment": {
    "id": a numerical unique id (e.g. 1),
    "name": some human-readable name of the threat_assessment,
    "selection": the geometry of the user-selected area, given in the GeoJSON notation as a Polygon object (without an inner ring).
    "start_date": beginning of the threat_assessment (timestamp),
    "end_date": end of the threat_assessment (timestamp),
    "status": current threat_assessment status. Permitted values are: "unknown", "started", "finished", "error"
    "section_ids": identifiers of sections which are covered by this threat_assessment,
    "results": all results registered for this threat_assessment
  }
}
```
## Create a new threat_assessment

Allows you to create a new threat_assessment. You can provide a name, initial status, start date, end date and selection polygon for the threat_assessment. You may also pass a list of section IDs which will be
covered by this threat_assessment.

You need to authorize yourself with an administrator account (a token).

```
POST /threat_assessments/
```

Parameters:

+ `name` (optional) - some human-readable name of the threat_assessment,
+ `selection` (optional) - the geometry of the user-selected area, given in the GeoJSON notation as a Polygon object (without an inner ring).
+ `start_date` (optional) - beginning of the threat_assessment (timestamp),
+ `end_date` (optional) - end of the threat_assessment (timestamp),
+ `status` (optional): current threat_assessment status. Permitted values are: "unknown", "started", "finished", "error",
+ `section_ids` (optional): an array of section IDs which are covered by this threat_assessment.

The operation return the JSON representation of the newly created threat_assessment

## Update the details of a given threat_assessment

Allows you to change selected details of an threat_assessment - specifically, its name, status, start_date, end_date, selection and list of sections. No other attributes of the threat_assessment can be changed through this operation. You need to authorize yourself with an administrator account (a token).

```
PUT /threat_assessments/:id
```

Parameters:

+ `id` (required) - The ID of the threat_assessment you are interested in, as returned by the GET /threat_assessments call
+ `name` (optional) - some human-readable name of the threat_assessment,
+ `selection` (optional) - the geometry of the user-selected area, given in the GeoJSON notation as a Polygon object (without an inner ring).
+ `start_date` (optional) - beginning of the threat_assessment (timestamp),
+ `end_date` (optional) - end of the threat_assessment (timestamp),
+ `status` (optional): current threat_assessment status. Permitted values are: "unknown", "started", "finished", "error"
+ `section_ids` (optional): identifiers of sections which are covered by this threat_assessment.

The operation return the JSON representation of this threat_assessment (much like the GET /threat_assessments/id operation), with the updated field values, or a suitable error code, when a problem occurs.