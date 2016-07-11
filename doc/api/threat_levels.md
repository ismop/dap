## List Threat Levels

Get a list of Threat Levels for all Profiles. You need to authorize yourself with an administrator account (a token).
By default five latest Threat Assessments for a profile are returned in Threat Level data. This can be altered by providing
an optional `limit` parameter.

```
GET /threat_levels[?limit=10]
```
Parameters:

+ `limit` (optional) defines how many latest Threat Assessments are returned.


```json
{
  "threat_levels":
    [
      {
        "profile_id": 3923,
        "threat_assessments":
          [
            {
              "date": "2016-07-11T08:02:24.449Z",
              "scenarios":
                [
                  {
                    "similarity": 0.8,
                    "threat_level": 2,
                    "scenario_id": 2057
                  },
                  {
                    "similarity": 0.4,
                    "threat_level": 1,
                    "scenario_id": 2058
                  }
                ]
            }
          ],
        "threat_level_assessment_runs": 
          [
            {
              "start_date": "2016-07-11T06:02:24.446Z",
              "status": "running",
              "explanation": "Assessment run has results produced less than two hours ago"
            }
          ]
      }
    ]
}
```