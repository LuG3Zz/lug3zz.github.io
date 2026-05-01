import { visit } from "unist-util-visit";
import { findAndReplace } from "mdast-util-find-and-replace";

// [[slug]] or [[slug|Display Text]] → [slug](/blog/slug) or [Display Text](/blog/slug)
function wikilinkPlugin() {
  return function (tree) {
    findAndReplace(tree, [
      [
        /\[\[([^|[\]]+)(?:\|([^[\]]+))?\]\]/g,
        function (match, target, display) {
          var slug = target.trim();
          var text = (display || slug).trim();
          var href = slug.startsWith("/") ? slug : slug.includes("/") ? "/" + slug : "/blog/" + slug;
          return { type: "link", url: href, children: [{ type: "text", value: text }] };
        },
      ],
    ]);
  };
}

// ![[image.png]] or ![[path/to/image.jpg]] → ![](/images/path/to/image.jpg)
function obsidianImagePlugin() {
  return function (tree) {
    visit(tree, "paragraph", function (node) {
      var i = node.children.length;
      while (i--) {
        var child = node.children[i];
        if (child.type !== "text") continue;
        var replaced = child.value.replace(
          /!\[\[([^[\]]+)\]\]/g,
          function (_, path) {
            var p = path.trim();
            var href = p.startsWith("/") ? p : "/images/" + p;
            return "![](" + href + ")";
          }
        );
        if (replaced !== child.value) {
          child.value = replaced;
        }
      }
    });
  };
}

// > [!note] Title → <blockquote class="callout callout-note">
// > Content
function calloutPlugin() {
  return function (tree) {
    visit(tree, "blockquote", function (node) {
      if (!node.children || node.children.length === 0) return;
      var first = node.children[0];
      if (first.type !== "paragraph" || !first.children || first.children.length === 0) return;
      var firstText = first.children[0].value || "";
      var match = firstText.match(/^\[!(\w+)\]\s*(.*)/i);
      if (!match) return;
      var type = match[1].toLowerCase();
      var titleText = match[2].trim();

      // Remove the [!type] prefix from first paragraph
      first.children[0].value = "";

      // If there's a title, insert it as a strong element at the start
      if (titleText) {
        first.children.unshift({ type: "strong", children: [{ type: "text", value: titleText }] });
        first.children.unshift({ type: "text", value: "" }); // separator
      }

      // Add class to blockquote
      node.data = node.data || {};
      node.data.hProperties = node.data.hProperties || {};
      node.data.hProperties.class = "callout callout-" + type;
    });
  };
}

export { wikilinkPlugin, obsidianImagePlugin, calloutPlugin };
