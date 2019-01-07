#  Endpoints

The ScrollRack API is designed to be RESTful (or at least *mostly* RESTful).

## Objects

There are multiple kinds of objects in the ScrollRack API:

- Users
- Cards — specific, individual cards owned by users
- Collections — groupings of a user's cards
- Decks — collections of cards (either owned or otherwise) that represent decks used for play
- Deck Folders — groupings of a user's decks; can be recursive (i.e., a deck folder can contain other deck folders)

## URIs

- `/api/v1/users` — all the users of ScrollRack
- `/api/v1/users/{id}` — a specific user
- `/api/v1/users/{id}/cards` — all of a user's cards
- `/api/v1/users/{id}/cards/{id}` — a specific card
- `/api/v1/users/{id}/collections` — all of a user's collections
- `/api/v1/users/{id}/collections/{id}` — a specific collection of cards
- `/api/v1/users/{id}/decks` — all of a user's decks (a flat list that disregards folders)
- `/api/v1/users/{id}/decks/{id}` — a specific deck
- `/api/v1/users/{id}/folders` — all of a user's deck folders
- `/api/v1/users/{id}/folders/{id}` — a specific deck folder

## HTTP Methods

- `HTTP GET    /api/v1/users` — get list of all users
- `HTTP POST   /api/v1/users` — create new user
- `HTTP GET    /api/v1/users/{id}` — get info about specific user
- `HTTP PUT    /api/v1/users/{id}` — update info about specific user
- `HTTP DELETE /api/v1/users/{id}` — delete specific user
- `HTTP GET    /api/v1/users/{id}/cards` — get list of all cards
- `HTTP POST   /api/v1/users/{id}/cards` — create new card
- `HTTP GET    /api/v1/users/{id}/cards/{id}` — get info about specific card
- `HTTP PUT    /api/v1/users/{id}/cards/{id}` — update info about specific card
- `HTTP DELETE /api/v1/users/{id}/cards/{id}` — delete specific card
- `HTTP GET    /api/v1/users/{id}/collections` — get list of all collections
- `HTTP POST   /api/v1/users/{id}/collections` — create new collection
- `HTTP GET    /api/v1/users/{id}/collections/{id}` — get info about specific collection
- `HTTP PUT    /api/v1/users/{id}/collections/{id}` — update info about specific collection
- `HTTP DELETE /api/v1/users/{id}/collections/{id}` — delete specific collection
- `HTTP GET    /api/v1/users/{id}/decks` — get list of all decks
- `HTTP POST   /api/v1/users/{id}/decks` — create new deck
- `HTTP GET    /api/v1/users/{id}/decks/{id}` — get info about specific deck
- `HTTP PUT    /api/v1/users/{id}/decks/{id}` — update info about specific deck
- `HTTP DELETE /api/v1/users/{id}/decks/{id}` — delete specific deck
- `HTTP GET    /api/v1/users/{id}/folders` — get list of all deck folders
- `HTTP POST   /api/v1/users/{id}/folders` — create new deck folder
- `HTTP GET    /api/v1/users/{id}/folders/{id}` — get info about specific deck folder
- `HTTP PUT    /api/v1/users/{id}/folders/{id}` — update info about specific deck folder
- `HTTP DELETE /api/v1/users/{id}/folders/{id}` — delete specific deck folder
