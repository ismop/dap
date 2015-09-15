## List sections

Get a list of all sections present in the registry.
You need to authorize yourself with an administrator account (a token).

```
GET /sections
```

```json
{
  "sections": [
    {
      "id": a numerical unique id (e.g. 1),
       "shape": the geometry of the section given in the GeoJSON notation,
       "levee_id": identifier of the levee the section belongs to
       "ground_type_label": identifier of the type of ground which comprises the section (if set)
       "ground_type_description": description of the type of ground which comprises the section (if set)
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
GET /section/:id
```

Parameters:

+ `id` (required) - The ID of the section you are interested in, as returned by the GET /sections call

```json
{
  "section": {
     "id": a numerical unique id (e.g. 1),
     "shape": the geometry of the section given in the GeoJSON notation,
     "levee_id": identifier of the levee the section belongs to
     "ground_type_label": identifier of the type of ground which comprises the section (if set)
     "ground_type_description": description of the type of ground which comprises the section (if set)
  }
}
```
