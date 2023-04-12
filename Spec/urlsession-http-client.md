# URLSession HTTP Client

## URLSession HTTP Client Representable States

| Data? | HTTPURLResponse? | Error? | Representable State |
|-------|------------------|--------|---------------------|
| nil   | nil              | nil    | invalid             |
| nil   | value            | nil    | valid               |
| nil   | nil              | value  | valid               |
| value | nil              | nil    | invalid             |
| value | value            | nil    | valid               |
| value | nil              | value  | invalid             |
| nil   | value            | value  | invalid             |
| value | value            | value  | invalid             |
