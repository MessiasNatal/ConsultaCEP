- Desenvolvido com Delphi CE 11 

- Instalação do componente ConsultaCEP: 
  1. Add no libray o ..\componentes\ConsultaCEP  
  3. Abrir ..\componentes\componentes.dpk build e install
  4. O componente fica na Paleta "Components by Messias"
  
- Foi utilizado o banco de dados Firebird 3.0

- Parametrização de inicialização do executavel:
  - Localização do arquivo ini em: ..\distribuicao\parametros\config.ini 
    - hostname: IP do servidor do banco de dados 
    - database: caminho do banco de dados ..\distribuicao\database\database.fdb  
    - Porta: porta do banco 
    - Lib: ..\distribuicao\fbclient.dll 
  
- Abertura do sistema pelo .exe em ..\distribuicao\ConsultaCEP.exe 

Comentário sobre a construção do sistema:

- O projeto criado exemplifica um cadastro de Pessoa que se chama Fonte Pagadora, no cadastro exige campos como Nome, CPF e os dados de endereço, 
o CEP pode ser digitado manualmete e ao precisar consultar basta clicar no botão com uma lupa para abrir a tela de pesquisa de CEP feita de acordo com  a solicitação.

- Toda a construção do projeto foi pensada em baixo acoplamento. Por exemplo, o uso do firedac será utilizado somente nos datamodules e 
classes específicas para seu uso, enquanto nas demais classes é utilizado o dSetPadrao do tipo TDataSet e o helper é usado para fazer o 
acesso ao firedac através de dSetPadrao.Query. Dessa forma, todas as minhas classes não têm vínculo com o firedac.

- O mesmo foi pensado na construção da Classe, todas herdam de Classe.Padrao. Nas telas, também não há uso da classe específica, sempre acessa o 
ObjPadrao e, através do helper, obtenho as especificações da classe desejada.

- As chamadas de telas seguem o mesmo objetivo, herdando de um padrão e, com base no register feito no initialization, eu instancio as telas através da string 
do nome da tela que o botão de chamada tem. As chamadas das classes também são feitas da mesma forma, sendo instanciadas pelo nome.

- Foi utilizado um arquivo de estilo para melhorar a aparência do sistema. O estilo foi customizado por mim.


