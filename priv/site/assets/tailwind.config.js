module.exports = {
  separator: '_',
  purge:
    process.env.NODE_ENV === "production"
      ? ["../*.slime", "../*.eex", "../**/*.slime", "../**/*.eex"]
      : [],
  darkMode: 'class',
  theme: {
    container: {
      center: true,
      padding: {
        DEFAULT: '1rem',
        sm: '1rem',
        lg: '1rem',
        xl: '1rem',
        '2xl': '1rem',
      },
      screens: {
        sm: '720px',
        md: '720px',
        lg: '720px',
        xl: '720px',
        '2xl': '720px',
      }
    },
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
        "my-white": "#FAF3FF",
        // "my-pink-light": "#fca5a5",
        // "my-purple-light": "#DFC7F4",
        "my-purple": "#BF6AFF",
        // "my-purple-darker": "#1D0631",
        // "my-orange": "#ff6500",
        fuchsia: {
          darker: '#200237',
          dark: '#40046F',
          DEFAULT: '#bf6aff'
        },
        black: {
          DEFAULT: "#090909",
          light: "#151515",
        },
      },
      fontFamily: {
        sans: ["Matter", "-apple-system", "BlinkMacSystemFont", "Segoe UI", "Roboto", "Helvetica", "Arial", "sans-serif", "Apple Color Emoji", "Segoe UI Emoji", "Segoe UI Symbol"],
        mono: ["FiraMono", "monospace"],
      },
      typography: (theme) => ({
        lg: {
          css: {
            lineHeight: 1.4,
            fontSize: 20,
          },
        },
        DEFAULT: {
          css: {
            color: theme("colors.my-white"),
            a: {
              color: "inherit",
              textDecorationThickness: "0.15rem",
              textDecorationColor: theme("colors.my-purple"),
              transition: ".25s ease-in-out",
              "&:hover": {
                color: theme("colors.my-purple"),
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
            "h1, h2, h3, h4": {
              marginTop: "3.6rem",
            },
            "h1, h2, h3, h4, p": {
              marginBottom: "1.3rem",
            },
            strong: {
              color: theme("colors.my-white"),
              fontWeight: "600",
            },
            img: {
              backgroundColor: theme("colors.white"),
              padding: theme("spacing.3"),
            },
            'a code': {
              color: theme("colors.my-white"),
              fontWeight: "600",
              backgroundColor: theme("colors.black.light"),
            },
            code: {
              color: theme("colors.my-white"),
              fontWeight: "600",
              backgroundColor: theme("colors.black.light"),
            },
            pre: {
              backgroundColor: theme("colors.black.DEFAULT"),
              color: "inherit",
              lineHeight: 1.3,
              marginLeft: `-${theme("spacing.3")}`,
              marginRight: `-${theme("spacing.3")}`,
            },
            "pre code": {
              fontFamily: "FiraMono, monospace",
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
      md: "800px",
      lg: "1200px",
      xl: "2000px",
    },
  },
  variants: {
    extend: {},
  },
  plugins: [
    require("@tailwindcss/typography"),
    function({ addUtilities, theme } = opts) {
      const extendUnderline = {
        ".underline": {
          textDecoration: "underline",
          textDecorationThickness: "0.15rem",
          textDecorationColor: theme("colors.my-purple"),
          transition: ".15s ease-in-out",
          "&:hover": {
            color: theme("colors.my-purple"),
          },
        },
        ".underline-current-color": {
          textDecorationColor: "currentColor",
        },
        ".text-hover-none": {
          "&:hover": {
            textDecorationColor: "currentColor",
            color: "currentColor",
          },
        },
      };

      addUtilities(extendUnderline);
    },
  ],
};
