import test from "ava";
import { parse } from "..";

test("interface definition", t => {
  const [actual] = parse(`
    interface Character {
      id: String!
      name: String
      friends: [Character]
      appearsIn: [Episode]
    }
  `);

  const expected = {
    type: "INTERFACE",
    name: "Character",
    fields: {
      id: { type: "String", required: true },
      name: { type: "String" },
      friends: { type: "Character", list: true },
      appearsIn: { type: "Episode", list: true }
    }
  };

  return t.same(actual, expected);
});
