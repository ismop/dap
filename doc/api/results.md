## List results

Get a list of all results present in the registry. You need to authorize yourself with an administrator account (a token).
Each result belongs to a section, a scenario and an threat_assessment.

```
GET /results
```

No parameters are required.

```json
{
  "results": [
    {
      "id": a numerical unique id (e.g. 1),
      "similarity": the smiliarity value which constitutes the payload of the result object (Float).
      "section_id": identifier of the section to which this result applies,
      "threat_assessment_id": identifier of the threat_assessment which generated this result,
      "scenario_id": identifier of the scenario to which this result applies.
    }, {
      ...
    }
  ]
}
```

## Details of a result

Get the JSON document about a given result. You need to authorize yourself with an administrator account (a token).

```
GET /results/:id
```

Parameters:

+ `id` (required) - The ID of the result you are interested in, as returned by the GET /results call

```json
{
  "result": {
    "id": a numerical unique id (e.g. 1),
    "similarity": the smiliarity value which constitutes the payload of the result object (Float),
    "section_id": identifier of the section to which this result applies,
    "threat_assessment_id": identifier of the threat_assessment which generated this result,
    "scenario_id": identifier of the scenario to which this result applies.
  }
}
```

Allows you to register a new result. You need to supply the similarity value (a float number) as well as the identifiers of this result's assigned section, threat_assessment and scenario.

You need to authorize yourself with an administrator account (a token).

```
POST /results/
```

Parameters:

+ `similarity` (required) - the similarity value which constitutes the payload of the result object (Float),
+ `section_id` (required) - the ID of the section to which this result applies,
+ `threat_assessment_id` (required) - the ID of the threat_assessment which generated this result,
+ `scenario_id` (required) - the ID of the scenario to which this result applies.

The operation return the JSON representation of the newly created result

## Update the details of a given threat_assessment

Allows you to change selected details of an threat_assessment - specifically, its name, status, start_date, end_date, selection and list of sections. No other attributes of the threat_assessment can be changed through this operation. You need to authorize yourself with an administrator account (a token).
