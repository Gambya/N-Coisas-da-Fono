# NCoisas da Fono

Bem-vindo ao **NCoisas da Fono**, um aplicativo Flutter desenvolvido para fonoaudiólogos gerenciarem consultas, pacientes e informações de forma prática e eficiente. Este app utiliza ObjectBox como banco de dados local e oferece uma interface intuitiva para organizar a rotina profissional.

## Descrição

O NCoisas da Fono é uma ferramenta projetada para fonoaudiólogos, permitindo o cadastro de médicos (o usuário principal), pacientes e consultas. Com uma navegação fluida entre telas, o app suporta:
- Registro de consultas com data e horário.
- Gerenciamento de pacientes com detalhes personalizados.
- Interface adaptada para uso diário, com suporte a pesquisa e navegação por datas.

O aplicativo é open-source e foi desenvolvido com Flutter, garantindo compatibilidade com Android e potencial para outras plataformas no futuro.

## Screenshots

Adicione aqui capturas de tela do aplicativo para demonstrar suas funcionalidades. Use o seguinte formato para incluir imagens:



Por favor, substitua os caminhos das imagens (ex.: `screenshots/home_screen.png`) pelos arquivos reais que você capturar do app. Certifique-se de colocá-los na pasta `screenshots/` no repositório e atualize os nomes conforme necessário.

## Instalação

### Via F-Droid

O NCoisas da Fono ainda não está disponível na F-Droid, mas você pode acompanhar o progresso para sua inclusão. Para instalar via F-Droid quando estiver disponível:

1. **Baixe o F-Droid**:
   - Acesse [f-droid.org](https://f-droid.org/) e instale o aplicativo F-Droid em seu dispositivo Android.

2. **Adicione o Repositório (se necessário)**:
   - Abra o F-Droid e vá para **Configurações > Repositórios**.
   - Adicione o repositório oficial do NCoisas da Fono (será fornecido quando publicado).

3. **Procure e Instale**:
   - Na barra de busca, digite "NCoisas da Fono".
   - Toque no app e selecione **Instalar**.

**[Nota]: Atualize esta seção com o link e instruções específicas quando o app for publicado na F-Droid.**

### Via Repositório e Flutter

Para executar o aplicativo localmente a partir do código-fonte usando Flutter, siga os passos abaixo:

1. **Pré-requisitos**:
   - Instale o [Flutter SDK](https://flutter.dev/docs/get-started/install) em seu sistema.
   - Configure um emulador Android ou conecte um dispositivo físico.
   - Certifique-se de ter o Dart e o Android SDK configurados.

2. **Clone o Repositório**:
   - Abra um terminal e execute o seguinte comando para clonar o repositório:
     ```bash
     git clone https://github.com/Gambya/NCoisas da Fono.git
     ```
    - Navegue até o diretório do projeto:
    ```bash
    cd NCoisas da Fono
    ```
3. **Instale as Dependências**:
    - Execute o comando para baixar as dependências listadas no `pubspec.yaml`:
    ```bash
    flutter pub get
    ```
4. **Gere os Arquivos do ObjectBox**:
    - Certifique-se de que os arquivos do ObjectBox estejam gerados. Execute:
    ```bash
    flutter pub run build_runner build --delete-conflicting-outputs
    ```
5. **Execute o Aplicativo**:
    - Inicie o app em um emulador ou dispositivo conectado:
    ```bash
    flutter run
    ```
    - O app será compilado e aberto automaticamente. Siga as instruções na tela para configurar o médico pela primeira vez.
6. **(Opcional) Build para APK**:
    - Para gerar um arquivo APK instalável, use:
    ```bash
    flutter build apk
    ```
    - O arquivo estará em `build/app/outputs/flutter-apk/app-release.apk`.

### Contribuições
Contribuições são bem-vindas! Sinta-se à vontade para abrir issues ou pull requests para sugerir melhorias, corrigir bugs ou adicionar novas funcionalidades.

### Licença
Este projeto está sob a [MIT License](https://grok.com/chat/LICENSE). Veja o arquivo `LICENSE` para mais detalhes.

