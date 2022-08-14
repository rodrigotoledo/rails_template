# RToledo Dev - tema para projetos rails

## Um pouco sobre

Este projeto serve apenas de ajuda para que novas aplicações sejam criadas com o básico que deve ter e digamos com qualidade.

## Requisitos

- rvm (desejável)
- rails 7.x
- conhecimentos com TDD

### Comandos

Para iniciar o projeto é sempre bom caso o mesmo utilize rvm, o nome do projeto e gemset sejam as mesmas. Então inicialmente uma boa prática seria rodar:

`rvm use 3.0.3@nome_do_projeto --create`

com isto a versão 3.0.3 do ruby será criada com a gemset `nome_do_projeto`

Após é necessário instalar o rails é claro, sem ele nada feito certo?!

`gem install rails --no-doc`

e finalmente criar o projeto seguindo o template com o comando abaixo

`rails new nome_do_projeto --css tailwind -T -m=template.rb`

## Comandos do projeto

- Para navegar no projeto entre pela pasta e execute
- `rails s`
- Logo em seguida acesse em  `http://localhost:3000`
- Para executar testes basta executar
- `bundle exec guard`
- e logo em seguida apertar **Enter**, assim todos os testes serão rodados