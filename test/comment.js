import test from "ava";
import { parse } from "..";

test("add '#' comments as description", t => {
  const [actual] = parse(`
    # FOO as in Foobar
    enum Bar { FOO }
  `);

  const expected = {
    type: "ENUM",
    name: "Bar",
    description: "FOO as in Foobar",
    values: ["FOO"]
  };

  return t.same(actual, expected);
});

test("add '//' comments as description", t => {
  const [actual] = parse(`
    // FOO as in Foobar
    enum Bar { FOO }
  `);

  const expected = {
    type: "ENUM",
    name: "Bar",
    description: "FOO as in Foobar",
    values: ["FOO"]
  };

  return t.same(actual, expected);
});

test("add '/**/' comments as description", t => {
  const [actual] = parse(`
    /*
      FOO as in Foobar
    */
    enum Bar { FOO }
  `);

  const expected = {
    type: "ENUM",
    name: "Bar",
    description: "FOO as in Foobar",
    values: ["FOO"]
  };

  return t.same(actual, expected);
});
