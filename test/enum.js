import test from "ava";
import { parse } from "..";

test("enum definition", t => {
  const actual = parse(`
    // One of the films in the Star Wars Trilogy
    enum Episode {
      NEWHOPE
      EMPIRE
      JEDI
    }
  `);

  const expected = [
    {
      type: "ENUM",
      name: "Episode",
      description: "One of the films in the Star Wars Trilogy",
      values: ["NEWHOPE", "EMPIRE", "JEDI"]
    }
  ];

  return t.same(actual, expected);
});
