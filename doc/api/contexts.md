## List Contexts

Get a list of all Contexts being registered in the registry. You need to authorize yourself with an administrator account (a token).

```
GET /contexts
```

No parameters are required.

```json
{
  "contexts": [
    {
      "id": a numerical unique id (e.g. 1),
      "name": some human-readable name of the Context,
      "context_type": one of "measurement", "tests".
    }, {
      ...
    }
  ]
}
```


## Details of a Context

Get the JSON document about a given Context. You need to authorize yourself with an administrator account (a token).

```
GET /contexts/:id
```

Parameters:

+ `id` (required) - The ID of the Levee you are interested in, as returned by the GET /levees call

```json
{
  "context": {
     "id": a numerical unique id (e.g. 1),
     "name": some human-readable name of the Context,
     "context_type": one of "measurement", "tests".
  }
}
```
