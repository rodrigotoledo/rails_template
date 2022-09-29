# RToledo Dev - tema para projetos rails

## Um pouco sobre

Este projeto serve apenas de ajuda para que novas aplicações sejam criadas com o básico que deve ter e digamos com qualidade.

## Requisitos

- rvm (desejável)
- rails 7.x
- conhecimentos com TDD

### Comandos

Para iniciar o projeto é sempre bom utilizar o versionamento de do ruby. E para isto aconselho usar [rvm](https://rvm.io/). Então inicialmente uma boa prática seria rodar:

`rvm install 3.1.2`

com isto a versão 3.1.2 do ruby será instalada

Após é necessário instalar o rails é claro, sem ele nada feito certo?!

`gem install rails --no-doc`

e finalmente criar o projeto seguindo o template com o comando abaixo

`rails new name_of_project --css tailwind -T -m=template.rb`

## Comandos do projeto

- Para navegar no projeto entre pela pasta e execute
- `cd name_of_project`
- `bundle`
- `rails s`
- Logo em seguida acesse em  `http://localhost:3000`
- Para executar testes basta executar
- `bundle exec guard`
- e logo em seguida apertar **Enter**, assim todos os testes serão rodados