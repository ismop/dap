## List results

Get a list of all results present in the registry. You need to authorize yourself with an administrator account (a token).
Each result belongs to a profile, a scenario and an threat_assessment.

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
      "rank": subjective rank assigned to this result by the threat assessment run (Int).
      "offset": offset of the result (Int),
      "payload": a string field containing result-specific details,
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
    "similarity": the smiliarity value which constitutes the payload of the result object (Float).
    "rank": subjective rank assigned to this result by the threat assessment run (Int).
    "offset": offset of the result (Int),
    "payload": a string field containing result-specific details,
    "threat_assessment_id": identifier of the threat_assessment which generated this result,
    "scenario_id": identifier of the scenario to which this result applies.
  }
}
```

Allows you to register a new result. You need to supply the similarity value (a float number) as well as the identifiers of this result's assigned threat_assessment and scenario.

You need to authorize yourself with an administrator account (a token).

```
POST /results/
```

Parameters:

+ `similarity` (required) - the similarity value which constitutes the payload of the result object (Float),
+ `rank` (required) - the rank value assigned to this result by the threat assessment run (Int),
+ `offset` (optional) - the offset value for this result (Int),
+ `payload` (optional) - any further metadata concerning the result (String),
+ `threat_assessment_id` (required) - the ID of the threat_assessment which generated this result,
+ `scenario_id` (required) - the ID of the scenario to which this result applies.

The operation return the JSON representation of the newly created result
