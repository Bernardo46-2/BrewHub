import 'dart:math';

enum MessageStatus {
  notSent,
  sent,
  received,
  read,
}

class Message {
  final String senderId;
  final String receiverId;
  final String content;
  final DateTime timestamp;
  final MessageStatus status;

  // Construtor
  Message({
    required this.senderId,
    required this.receiverId,
    required this.content,
    required this.timestamp,
    this.status = MessageStatus.notSent, // padrão para não enviado
  });

  // Converter um objeto Message em um mapa para armazenamento ou envio
  Map<String, dynamic> toJson() {
    return {
      'senderId': senderId,
      'receiverId': receiverId,
      'content': content,
      'timestamp': timestamp.toIso8601String(),
      'status': status.index, // converte o enum para int
    };
  }

  // Converter um mapa em um objeto Message
  static Message fromMap(Map<String, dynamic> map) {
    return Message(
      senderId: map['senderId'],
      receiverId: map['receiverId'],
      content: map['content'],
      timestamp: DateTime.parse(map['timestamp']),
      status: MessageStatus.values[map['status']],
    );
  }
}

class ChatSimulator {
  final List<String> _phrases = [
    "Olá!",
    "Como vai?",
    "Tudo bem?",
    "Bom dia!",
    "Boa tarde!",
    "Boa noite!",
    "Que tempo louco hoje!",
    "Na próxima reunião, eu vou sugerir dançar a Macarena como quebra-gelo.",
    "Minha receita secreta para o jantar é macarrão com ketchup.",
    "Descobri que meu gato tem uma conta bancária na Suíça.",
    "Eu costumo escovar os dentes com molho de mostarda.",
    "Qual é o seu filme favorito de todos os tempos?",
    "Você já experimentou essa comida?",
    "Como você aprendeu a fazer isso?",
    "Qual é o seu livro favorito?",
    "Você já foi a algum concerto recentemente?",
    "Qual é o seu lugar preferido para relaxar?",
    "Tenho que correr para uma reunião agora.",
    "Você já visitou um lugar incrível?",
    "Tenha um ótimo dia!",
    "Eu estava pensando em viajar este ano.",
    "Estou animado para o feriado!",
    "Você gosta de esportes?",
    "Que tipo de música você ouve?",
    "O que você faz no seu tempo livre?",
    "Quais são os seus planos para o fim de semana?",
    "Você já visitou algum parque nacional?",
    "Gosto de fazer caminhadas na natureza.",
    "Você já fez algum voluntariado?",
    "Você pratica algum esporte?",
    "Estou planejando uma viagem à Lua no próximo verão.",
    "Eu nunca saio de casa sem meu chapéu de papel alumínio.",
    "Quando estou estressado, danço a valsa com um manequim.",
    "Meu desejo secreto é ser um pinguim por um dia.",
    "Eu inventei uma nova língua chamada 'Gibberish' e estou escrevendo um dicionário para ela.",
    "Eu coleciono adesivos de frutas e os colo em todas as minhas roupas.",
    "Minha estratégia de trabalho é resolver todos os problemas com um duelo de polegares de esgrima.",
    "Na próxima vez que eu for ao dentista, vou pedir uma coroa de ouro para cada dente.",
    "Meu lema de vida é 'Nunca diga nunca a um sanduíche de banana com bacon'.",
    "Eu ganhei um concurso de dança do robô em minha cidade natal.",
    "Minha técnica de meditação envolve contar quantos cabelos tenho na cabeça.",
    "Na próxima festa à fantasia, vou de abacaxi espacial.",
    "Minha ideia de negócio é criar um serviço de entrega de abraços virtuais.",
    "Eu uso meias diferentes todos os dias da semana, de propósito.",
    "Minha superpotência dos sonhos é fazer com que todos os semáforos fiquem verdes quando eu chegar perto.",
    "Na próxima reunião de trabalho, vou sugerir que tenhamos um mascote: um esquilo de estimação.",
    "Eu costumo comer pizza com molho de chocolate.",
    "Descobri que minha planta de casa adora ouvir heavy metal.",
    "Meu plano secreto é construir uma casa na árvore gigante.",
    "Meu esporte favorito é o salto de trampolim com uma bacia de macarrão na cabeça.",
    "Na próxima festa, todos terão que vestir pijamas de abacaxi.",
    "Minha ideia brilhante é criar um parque temático de lagartas de pelúcia.",
    "Meu passatempo favorito é colecionar meias desparelhadas.",
    "Na última festa, alguém trouxe um elefante de estimação.",
    "Estou planejando uma viagem para o centro da Terra no próximo verão.",
    "Eu nunca saio de casa sem minha coleção de pedras mágicas.",
    "Quando estou estressado, grito 'Bananalândia' em voz alta.",
    "Meu desejo secreto é ser um guaxinim por um dia.",
    "Na minha próxima festa, todos terão que dançar a polca com polainas cor-de-rosa.",
    "Eu inventei uma nova dança chamada 'O Agitado Polvo' e estou planejando fazer um vídeo viral.",
    "Eu coleciono garfos de plástico usados e os exponho em minha parede como arte abstrata.",
    "Minha estratégia de trabalho é resolver todos os conflitos com um concurso de arrotos.",
    "Na próxima vez que eu for ao dentista, vou pedir um aparelho de diamantes.",
    "Meu lema de vida é 'Sempre use óculos de sol à noite'.",
    "Eu ganhei um concurso de imitação de pato em minha cidade natal.",
    "Minha técnica de meditação envolve contar as bolhas em um copo de refrigerante.",
    "Na próxima festa à fantasia, vou de girafa ninja.",
    "Minha ideia de negócio é criar um serviço de entrega de serenatas por pombos-correio.",
    "Eu uso um par de meias de cada cor, sempre.",
    "Minha superpotência dos sonhos é fazer com que todas as portas se abram com um simples assobio.",
    "Na próxima reunião de trabalho, vou sugerir que tenhamos um hino nacional para a empresa.",
    "Eu costumo comer sorvete com ketchup.",
    "Descobri que meu peixinho dourado é um gênio matemático.",
    "Meu plano secreto é construir um castelo de areia no quintal.",
    "Meu esporte favorito é o mergulho sincronizado em uma piscina de gelatina.",
    "Na próxima festa, todos terão que usar gravatas-borboleta fluorescentes.",
    "Minha ideia brilhante é abrir um parque de diversões para caracóis.",
    "Meu passatempo favorito é fazer esculturas de banana.",
    "Na última festa, alguém trouxe um robô como acompanhante.",
    "Estou planejando uma viagem para a Antártica no próximo verão.",
    "Eu nunca saio de casa sem meu catálogo de piadas de palhaço.",
    "Quando estou estressado, faço uma dança da galinha no escritório.",
    "Meu desejo secreto é ser um pinguim de circo por um dia.",
    "Na minha próxima festa, todos terão que usar óculos de natação.",
    "Eu inventei um novo esporte chamado 'Corrida de Tartarugas' e estou organizando um torneio.",
    "Eu coleciono capas de garrafas de ketchup e as uso como capas de chuva.",
    "Minha estratégia de trabalho é resolver todos os desafios com um concurso de caretas.",
    "Na próxima vez que eu for ao dentista, vou pedir uma coroa de",
    "Qual é o seu aplicativo favorito?",
    "Estou tentando ser mais saudável ultimamente.",
    "Você já assistiu a um filme cult?",
    "Adoro assistir ao pôr do sol.",
    "Você já fez um cruzeiro?",
    "Eu estava lendo um livro incrível recentemente.",
    "Você já visitou um parque de diversões aquático?",
    "Gosta de fazer artesanato?",
    "Qual é o seu projeto de artesanato mais recente?",
    "Você já visitou um aquário?",
    "Prefere ler livros físicos ou digitais?",
    "Qual é o seu livro favorito de todos os tempos?",
    "Você já fez um curso de fotografia?",
    "Gosta de passeios de barco?",
    "Qual é o seu animal marinho favorito?",
    "Você já fez um safari?",
    "Minha técnica de meditação envolve contar as bolhas em um copo de refrigerante.",
    "Na próxima festa à fantasia, vou de girafa ninja.",
    "Minha ideia de negócio é criar um serviço de entrega de serenatas por pombos-correio.",
    "Eu uso um par de meias de cada cor, sempre.",
    "Minha superpotência dos sonhos é fazer com que todas as portas se abram com um simples assobio.",
    "Na próxima reunião de trabalho, vou sugerir que tenhamos um hino nacional para a empresa.",
    "Eu costumo comer sorvete com ketchup.",
    "Descobri que meu peixinho dourado é um gênio matemático.",
    "Meu plano secreto é construir um castelo de areia no quintal.",
    "Meu esporte favorito é o mergulho sincronizado em uma piscina de gelatina.",
    "Na próxima festa, todos terão que usar gravatas-borboleta fluorescentes.",
    "Minha ideia brilhante é abrir um parque de diversões para caracóis.",
    "Meu passatempo favorito é fazer esculturas de banana.",
    "Na última festa, alguém trouxe um robô como acompanhante.",
    "Estou planejando uma viagem para a Antártica no próximo verão.",
    "Eu nunca saio de casa sem meu catálogo de piadas de palhaço.",
    "Quando estou estressado, faço uma dança da galinha no escritório.",
    "Meu desejo secreto é ser um pinguim de circo por um dia.",
    "Na minha próxima festa, todos terão que usar óculos de natação.",
    "Eu inventei um novo esporte chamado 'Corrida de Tartarugas' e estou organizando um torneio.",
    "Eu coleciono capas de garrafas de ketchup e as uso como capas de chuva.",
    "Minha estratégia de trabalho é resolver todos os desafios com um concurso de caretas.",
    "Na próxima vez que eu for ao dentista, vou pedir uma coroa de marshmallow",
    "Minha próxima invenção será uma máquina que traduz miados de gatos em poesia épica."
    "Costumo usar uma sombrinha de praia para me proteger da chuva.",
    "Estou pensando em criar uma academia de ginástica para hamsters.",
    "Meu plano para o futuro é abrir um restaurante temático de comida intergaláctica.",
    "Na minha lista de afazeres, tenho 'Aprender a falar fluentemente em emoji'.",
    "Sempre cumprimento os esquilos que encontro no parque com um aperto de mão.",
    "Minha estratégia para lidar com o trânsito é cantar ópera no volante.",
    "Estou treinando meu cachorro para ser o próximo presidente do país.",
    "Minha técnica de relaxamento envolve fazer bolhas gigantes de sabão no banho.",
    "Na próxima festa, todos terão que se vestir como personagens de desenhos animados dos anos 80.",
    "Meu sonho é construir uma cidade subaquática habitada por sereias e unicórnios.",
    "Estou escrevendo um livro de receitas com pratos feitos apenas de alimentos verdes.",
    "Meu animal de estimação é um papagaio que fala em latim.",
    "Na minha próxima viagem, pretendo explorar as selvas urbanas das grandes cidades.",
    "Minha estratégia para resolver conflitos familiares é realizar competições de cuspe à distância.",
    "Quando me sinto triste, assisto a vídeos de gatos fazendo yoga.",
    "Minha ideia de negócio é abrir uma loja que venda roupas para vegetais de estimação.",
    "Estou planejando uma expedição para encontrar a lendária cidade de Atlantis no meu quintal.",
    "Sempre durmo com um capacete de astronauta para sonhar com viagens espaciais.",
    "Na próxima reunião de trabalho, vou sugerir que todos usem narizes de palhaço para aumentar a criatividade.",
    "Minha bebida favorita é suco de abóbora com gás.",
    "Tenho uma coleção de rochas que se parecem com celebridades.",
    "Meu passatempo secreto é treinar minhocas para participar de competições de corrida.",
    "Na última festa, alguém trouxe um unicórnio como acompanhante.",
    "Estou planejando uma viagem para Marte no próximo verão.",
    "Nunca saio de casa sem meu detector de aliens.",
    "Quando estou entediado, faço esculturas de areia no sofá.",
    "Meu desejo secreto é ser um super-herói que combate o crime usando abraços.",
    "Minha próxima fantasia de Halloween será de abacate espacial.",
    "Eu tenho uma playlist de músicas para acalmar plantas de interior.",
    "Meu plano é criar uma máquina que transforma pensamentos em donuts.",
    "Estou escrevendo um romance sobre um triângulo amoroso entre um narval, uma sereia e um yeti.",
    "Minha estratégia para resolver problemas é jogar pedra, papel, tesoura comigo mesmo.",
    "Na próxima vez que eu for ao supermercado, vou comprar apenas comidas que rimam.",
    "Meu lema de vida é 'Nunca diga não a uma festa de dança de galinhas'.",
    "Estou treinando um exército de patos para marchar em formação.",
    "Minha técnica de meditação envolve contar as estrelas em um céu holográfico.",
    "Na minha próxima festa, todos terão que usar óculos de sol à noite.",
    "Eu crio obras de arte usando apenas macarrão cru e cola.",
    "Meu plano para o fim de semana é escalar uma montanha de marshmallows.",
    "Quando estou entediado, faço dublagens para os miados dos gatos da vizinhança.",
    "Estou desenvolvendo um aplicativo que traduz grunhidos de porcos em Shakespeare.",
    "Minha ideia de negócio é abrir um spa para alienígenas.",
    "Na próxima vez que eu for ao dentista, vou pedir um aparelho de dentes de ouro.",
    "Meu esporte favorito é o lançamento de almofadas.",
    "Tenho uma coleção de canetas que só escrevem em hieróglifos.",
    "Meu super-herói favorito é o Homem-Sanduíche, que luta contra a fome no mundo.",
    "Estou treinando meu papagaio para dar palestras motivacionais.",
    "Minha estratégia para encontrar coisas perdidas é contratar um detetive de patos.",
    "Nunca deixo de carregar uma lanterna em forma de cenoura, caso a noite fique com fome.",
  ];

  String get randomMessage => _phrases[_randomIndex];

  int get _randomIndex => Random().nextInt(_phrases.length);
}