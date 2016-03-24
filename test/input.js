import test from "ava";
import { parse } from "..";

test("input definition", t => {
  const [actual] = parse(`
    // A Person
    input Person {
      id: String!
      name: String
    }
  `);

  const expected = {
    type: "INPUT",
    name: "Person",
    description: "A Person",
    fields: {
      id: { type: "String", required: true },
      name: { type: "String" }
    }
  };

  return t.same(actual, expected);
});


test("input with default values", t => {
  const [actual] = parse(`
    // A Person
    input Person {
      id: String!
      firstname: String = "Hans"
      lastname: String = "Wurst"
    }
  `);

  const expected = {
    type: "INPUT",
    name: "Person",
    description: "A Person",
    fields: {
      id: { type: "String", required: true },
      firstname: { type: "String", defaultValue: "Hans" },
      lastname: { type: "String", defaultValue: "Wurst" }
    }
  };

  return t.same(actual, expected);
});

