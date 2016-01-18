import babel from "rollup-plugin-babel";
import pegjs from "rollup-plugin-pegjs";

export default {
  entry: "src/graphql-shorthand.pegjs",
  dest: "dist/graphql-shorthand.js",
  format: "cjs",
  plugins: [
    pegjs(),
    babel()
  ]
}
