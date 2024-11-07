# NUTRAMOVE 

Este é um projeto Flutter chamado **NUTRAMOVE**, desenvolvido para gerenciar e monitorar rotinas de exercícios físicos. Ele utiliza navegação estruturada e personalizada, autenticação de usuários e algumas ferramentas populares no Flutter para aprimorar a experiência do usuário.

## Tecnologias Utilizadas

### 1. Flutter
Flutter é o framework principal para o desenvolvimento deste projeto, permitindo criar uma interface de usuário rica e responsiva para dispositivos móveis e web a partir de um único código-base. O projeto utiliza **Dart** como linguagem de programação e diversas bibliotecas para melhorar a funcionalidade do app.

### 2. Auto Route
A estrutura de navegação do aplicativo é baseada no pacote **Auto Route**, que facilita a configuração de rotas e navegação aninhada de maneira clara e escalável. O uso de **Auto Route** permite definir rotas dinâmicas, rotas protegidas (usando guards) e rotas aninhadas, melhorando a organização e o fluxo da aplicação.

### 3. Toastification
Para exibir mensagens e notificações rápidas, utilizamos o **Toastification**, que fornece notificações elegantes e customizáveis. Isso é útil para alertas de erro, mensagens de sucesso e outras comunicações rápidas com o usuário.

### 4. http.dart
Para requisições HTTP, o projeto usa o pacote **http.dart**. Ele permite que o app interaja com APIs externas e manipule dados de forma eficiente, garantindo que o usuário tenha acesso a informações atualizadas sobre exercícios, perfis e outras funcionalidades.

## Estrutura de Rotas e Navegação Aninhada

O projeto utiliza um sistema de rotas avançado, com navegação aninhada e guards de segurança, proporcionando uma experiência de usuário personalizada e segura.

### Navegação Aninhada (Nested Navigation)

A navegação aninhada permite que o aplicativo organize rotas relacionadas em "pilhas" de navegação dentro de uma rota principal, oferecendo uma estrutura mais intuitiva para o usuário. No caso do NUTRAMOVE, a navegação aninhada é utilizada para organizar áreas principais do app, como a seção de exercícios, a tela inicial e a área de administração de usuários. Essa abordagem permite que o usuário navegue entre essas seções sem perder o contexto da aplicação, mantendo a navegação centralizada na barra principal, o que melhora a experiência e o fluxo.

Por exemplo, dentro da rota principal do aplicativo, a barra de navegação exibe diferentes opções (como **Home**, **Exercises**, **Admin**), e cada uma delas pode ter sub-rotas específicas. Isso cria uma estrutura onde o usuário pode alternar entre diferentes partes da aplicação de forma eficiente e intuitiva, sem sair do escopo da navegação principal.

### Guards de Autenticação e Autorização

Para garantir a segurança e a personalização no acesso, o NUTRAMOVE utiliza **guards** para proteger rotas sensíveis. Existem dois tipos de guards implementados:

- **AuthGuard**: Esse guard garante que apenas usuários autenticados possam acessar determinadas rotas. Assim, o usuário precisa estar logado para acessar áreas como a tela de exercícios ou o perfil.
  
- **AdminGuard**: Este guard adiciona uma camada extra de segurança para seções que apenas administradores podem acessar, como a área de administração de usuários. Ele verifica se o usuário tem privilégios administrativos além de estar autenticado, limitando o acesso a funções de gerenciamento avançadas apenas para usuários autorizados.

Essa estrutura de navegação com guards e navegação aninhada proporciona um fluxo seguro e organizado, permitindo que o aplicativo diferencie o acesso com base nos privilégios do usuário, garantindo uma experiência segura e eficiente.
