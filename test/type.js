import test from "ava";
import { parse } from "..";

test("type definition", t => {
  const actual = parse(`
    // A humanoid creature in the Star Wars universe
    type Human : Character {
      id: String!
      name: String
      friends: [Character]
      appearsIn: [Episode]
      homePlanet: String
    }
  `);

  const expected = [
    {
      type: "TYPE",
      name: "Human",
      description: "A humanoid creature in the Star Wars universe",
      interfaces: ["Character"],
      fields: {
        id: { type: "String", required: true },
        name: { type: "String" },
        friends: { type: "Character", list: true },
        appearsIn: { type: "Episode", list: true },
        homePlanet: { type: "String" }
      }
    }
  ];

  return t.same(actual, expected);
});

test("type definition with parameters", t => {
  const actual = parse(`
    type Query {
      hero(episode: Episode): Character
      human(id: String!): Human
      droid(id: String!): Droid
    }
  `);

  const expected = [
    {
      type: "TYPE",
      name: "Query",
      fields: {
        hero: {
          type: "Character",
          args: { episode: { type: "Episode" } }
        },
        human: {
          type: "Human",
          args: { id: { type: "String", required: true } }
        },
        droid: {
          type: "Droid",
          args: { id: { type: "String", required: true } }
        }
      }
    }
  ];

  return t.same(actual, expected);
});
