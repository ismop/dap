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
       "levee_id": identifier of the levee the section belongs to,
       "soil_type_label": identifier of the type of soil which comprises the section (if set),
       "soil_type_name": description of the type of soil which comprises the section (if set),
       "bulk_density_min": minimum bulk density of soil which comprises the section (if set),
       "bulk_density_max": maximum bulk density of soil which comprises the section (if set),
       "bulk_density_avg": average bulk density of soil which comprises the section (if set),
       "granular_density_min": minimum granular density of soil which comprises the section (if set),
       "granular_density_max": maximum granular density of soil which comprises the section (if set),
       "granular_density_avg": average granular density of soil which comprises the section (if set),
       "filtration_coefficient_min": minimum filtration coefficient of soil which comprises the section (if set),
       "filtration_coefficient_max": maximum filtration coefficient of soil which comprises the section (if set),
       "filtration_coefficient_avg": average filtration coefficient of soil which comprises the section (if set)
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
     "levee_id": identifier of the levee the section belongs to,
       "soil_type_label": identifier of the type of soil which comprises the section (if set),
       "soil_type_name": description of the type of soil which comprises the section (if set),
       "bulk_density_min": minimum bulk density of soil which comprises the section (if set),
       "bulk_density_max": maximum bulk density of soil which comprises the section (if set),
       "bulk_density_avg": average bulk density of soil which comprises the section (if set),
       "granular_density_min": minimum granular density of soil which comprises the section (if set),
       "granular_density_max": maximum granular density of soil which comprises the section (if set),
       "granular_density_avg": average granular density of soil which comprises the section (if set),
       "filtration_coefficient_min": minimum filtration coefficient of soil which comprises the section (if set),
       "filtration_coefficient_max": maximum filtration coefficient of soil which comprises the section (if set),
       "filtration_coefficient_avg": average filtration coefficient of soil which comprises the section (if set)
  }
}
```
