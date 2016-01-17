# GraphQL Shorthand Parser

Parse GraphQL shorthand notation into a JSON object that can be used to
auto-generate schema files.

### Shorthand notation
```
// One of the films in the Star Wars Trilogy
enum Episode {
  NEWHOPE
  EMPIRE
  JEDI
}

// A character in the Star Wars Trilogy
interface Character {
  id: String!               // The id of the character
  name: String              // The name of the character
  friends: [Character]      // The friends of the character, or an empty list if they have none
  appearsIn: [Episode]      // Which movies they appear in
}

// A humanoid creature in the Star Wars universe
type Human : Character {
  id: String!               // The id of the human
  name: String              // The name of the human
  friends: [Character]      // The friends of the character, or an empty list if they have none
  appearsIn: [Episode]      // Which movies they appear in
  homePlanet: String        // The home planet of the human, or null if unknown
}

// A mechanical creature in the Star Wars universe
type Droid : Character {
  id: String!               // The id of the droid
  name: String              // The name of the droid
  friends: [Character]      // The friends of the character, or an empty list if they have none
  appearsIn: [Episode]      // Which movies they appear in
  primaryFunction: String   // The primary function of the droid
}

type Query {
  hero(episode: Episode): Character
  human(id: String!): Human
  droid(id: String!): Droid
}
```

### Parsed notation to JSON
```json
[
  {
    "type": "ENUM",
    "name": "Episode",
    "description": "One of the films in the Star Wars Trilogy",
    "values": [
      "NEWHOPE",
      "EMPIRE",
      "JEDI"
    ]
  },
  {
    "type": "INTERFACE",
    "name": "Character",
    "description": "A character in the Star Wars Trilogy",
    "fields": {
      "id": {
        "description": "The id of the character",
        "type": "String",
        "required": true
      },
      "name": {
        "description": "The name of the character",
        "type": "String",
        "required": false
      },
      "friends": {
        "description": "The friends of the character, or an empty list if they have none",
        "type": "Character",
        "required": false,
        "array": true
      },
      "appearsIn": {
        "description": "Which movies they appear in",
        "type": "Episode",
        "required": false,
        "array": true
      }
    }
  },
  {
    "type": "TYPE",
    "name": "Human",
    "description": "A humanoid creature in the Star Wars universe",
    "fields": {
      "id": {
        "description": "The id of the human",
        "type": "String",
        "required": true
      },
      "name": {
        "description": "The name of the human",
        "type": "String",
        "required": false
      },
      "friends": {
        "description": "The friends of the character, or an empty list if they have none",
        "type": "Character",
        "required": false,
        "array": true
      },
      "appearsIn": {
        "description": "Which movies they appear in",
        "type": "Episode",
        "required": false,
        "array": true
      },
      "homePlanet": {
        "description": "The home planet of the human, or null if unknown",
        "type": "String",
        "required": false
      }
    },
    "interfaces": [
      "Character"
    ]
  },
  {
    "type": "TYPE",
    "name": "Droid",
    "description": "A mechanical creature in the Star Wars universe",
    "fields": {
      "id": {
        "description": "The id of the droid",
        "type": "String",
        "required": true
      },
      "name": {
        "description": "The name of the droid",
        "type": "String",
        "required": false
      },
      "friends": {
        "description": "The friends of the character, or an empty list if they have none",
        "type": "Character",
        "required": false,
        "array": true
      },
      "appearsIn": {
        "description": "Which movies they appear in",
        "type": "Episode",
        "required": false,
        "array": true
      },
      "primaryFunction": {
        "description": "The primary function of the droid",
        "type": "String",
        "required": false
      }
    },
    "interfaces": [
      "Character"
    ]
  },
  {
    "type": "TYPE",
    "name": "Query",
    "fields": {
      "hero": {
        "type": "Character",
        "required": false,
        "args": {
          "episode": {
            "type": "Episode",
            "required": false
          }
        }
      },
      "human": {
        "type": "Human",
        "required": false,
        "args": {
          "id": {
            "type": "String",
            "required": true
          }
        }
      },
      "droid": {
        "type": "Droid",
        "required": false,
        "args": {
          "id": {
            "type": "String",
            "required": true
          }
        }
      }
    }
  }
]
```