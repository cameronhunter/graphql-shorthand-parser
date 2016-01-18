import test from "ava";
import { parse } from "..";

test("enum definition", t => {
  const [actual] = parse(`
    enum Episode {
      NEWHOPE,
      EMPIRE,
      JEDI
    }
  `);

  const expected = {
    type: "ENUM",
    name: "Episode",
    values: ["NEWHOPE", "EMPIRE", "JEDI"]
  };

  return t.same(actual, expected);
});

test("enum definition using commas", t => {
  const [actual] = parse(`
    enum Episode { NEWHOPE, EMPIRE, JEDI }
  `);

  const expected = {
    type: "ENUM",
    name: "Episode",
    values: ["NEWHOPE", "EMPIRE", "JEDI"]
  };

  return t.same(actual, expected);
});
