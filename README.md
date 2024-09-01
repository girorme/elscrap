# elscrap
Simple sraping tool made in elixir

Artigo: [https://girorme.github.io/2020/12/17/Elixir-e-o-web-scraping/](https://girorme.github.io/en/posts/elixir-webscraping/)

### Build
```
mix escript.build
```

### Run
```
./bin/elscrap --extract-links --url "https://github.com" --save
```

Urls wi'll be written to `output/links.txt`
