module.exports = {
  purge:
    process.env.NODE_ENV === "production"
      ? ["../*.slime", "../*.eex", "../**/*.slime", "../**/*.eex"]
      : [],
  darkMode: false,
  theme: {
    extend: {
      animation: {
        "gradient-x": "gradient-x 7s ease infinite",
      },
      keyframes: {
        "gradient-x": {
          "0%, 100%": {
            "background-size": "200% 200%",
            "background-position": "left center",
          },
          "50%": {
            "background-size": "200% 200%",
            "background-position": "right center",
          },
        },
      },
      height: {
        60: "60vh",
        "almost-full": "80vh",
        "almost-almost-full": "90vh",
      },
      colors: {
        "my-white": "#ffceae",
        "my-pink-light": "#fca5a5",
        "my-purple-light": "#DFC7F4",
        "my-purple": "#cb90f9",
        "my-purple-darker": "#1D0631",
        "my-orange": "#ff6500",
        black: {
          DEFAULT: "#090909",
          light: "#151515",
        },
      },
      fontFamily: {
        sans: ["IBMPlexSans", "system-ui"],
        mono: ["IBMPlexMono", "monospace"],
        condensed: ["IBMPlexSansCondensed", "system-ui"],
      },
      typography: (theme) => ({
        music: {
          css: {
            fontFamily: theme("fontFamily.sans"),
            color: theme("colors.white"),
            lineHeight: 1.4,
            fontSize: theme("fontSize.base"),
            a: {
              color: theme("colors.my-purple"),
              "&:hover": {
                color: theme("colors.my-orange"),
              },
            },
          },
        },
        lg: {
          css: {
            color: theme("colors.my-white"),
            lineHeight: 1.3,
            fontSize: 20,
            a: {
              color: theme("colors.my-purple"),
              "&:hover": {
                color: theme("colors.my-orange"),
              },
            },
            h1: {
              color: theme("colors.my-white"),
              fontWeight: "800",
            },
            h2: {
              color: theme("colors.my-white"),
              fontWeight: "700",
            },
            h3: {
              color: theme("colors.my-white"),
              fontWeight: "600",
            },
            h4: {
              color: theme("colors.my-white"),
              fontWeight: "600",
            },
            strong: {
              color: theme("colors.my-white"),
              fontWeight: "600",
            },
            img: {
              backgroundColor: theme("colors.white"),
              padding: theme("spacing.3"),
            },
            code: {
              color: theme("colors.my-white"),
              fontWeight: "600",
            },
            pre: {
              backgroundColor: theme("colors.black.light"),
              color: "inherit",
              lineHeight: 1.3,
            },
            "pre code": {
              fontFamily: "IBMPlexMono, monospace",
              backgroundColor: "transparent",
              borderWidth: "0",
              borderRadius: "0",
              padding: "0",
              fontWeight: "400",
              color: "inherit",
              fontSize: "inherit",
              lineHeight: "inherit",
            },
            blockquote: {
              color: "inherit",
              backgroundColor: theme("colors.black.light"),
              padding: theme("spacing.6"),
              border: 0,
            },
            "blockquote p:first-child": {
              marginTop: 0,
            },
            "blockquote p:last-child": {
              marginBottom: 0,
            },
            "ul > li::before": {
              backgroundColor: theme("colors.my-white"),
            },
          },
        },
      }),
    },
    screens: {
      sm: "600px",
      md: "900px",
    },
  },
  variants: {
    extend: {},
  },
  plugins: [require("@tailwindcss/typography")],
};
