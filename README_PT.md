# NCoisas da Fono

Bem-vindo ao **NCoisas da Fono**, um aplicativo Flutter desenvolvido para fonoaudiólogos gerenciarem consultas, pacientes e informações de forma prática e eficiente. Este app utiliza ObjectBox como banco de dados local e oferece uma interface intuitiva para organizar a rotina profissional.

## Descrição

O NCoisas da Fono é uma ferramenta projetada para fonoaudiólogos, permitindo o cadastro de médicos (o usuário principal), pacientes e consultas. Com uma navegação fluida entre telas, o app suporta:
- Registro de consultas com data e horário.
- Gerenciamento de pacientes com detalhes personalizados.
- Interface adaptada para uso diário, com suporte a pesquisa e navegação por datas.

O aplicativo é open-source e foi desenvolvido com Flutter, garantindo compatibilidade com Android e potencial para outras plataformas no futuro.

## Screenshots



<table>
  <tr>
    <td align="center">
      <img src="assets/screenshots/2.jpg" alt="Tela Consultas" width="300"/>
      <br>Tela Consultas
    </td>
    <td align="center">
      <img src="assets/screenshots/1.jpg" alt="Listagem de Pacientes" width="300"/>
      <br>Listagem de Pacientes
    </td>
    <td align="center">
      <img src="assets/screenshots/3.jpg" alt="Registro de Consulta" width="300"/>
      <br>Perfil do Paciente
    </td>
  </tr>
  <tr>
    <td align="center">
      <img src="assets/screenshots/4.jpg" alt="Edição de Paciente" width="300"/>
      <br>Edição de Paciente
    </td>
    <td align="center">
      <img src="assets/screenshots/5.jpg" alt="Anotações sobre pacientes" width="300"/>
      <br>Anotações Paciente
    </td>
    <td align="center">
      <img src="assets/screenshots/6.jpg" alt="Perfil do Paciente" width="300"/>
      <br>Perfil do Paciente
    </td>
  </tr>
</table>

## Instalação

### Via Release

1. **Baixe o NCoisas da Fono Release**:
   - Acesse [Releases](https://github.com/Gambya/N-Coisas-da-Fono/releases/) e instale o aplicativo aceitando as solicitações de segurança do dispositivo Android.

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
Este projeto está sob a [MIT License](LICENSE). Veja o arquivo `LICENSE` para mais detalhes.

