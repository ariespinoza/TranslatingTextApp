//
//  TranslateViewModel.swift
//  TranslatingTextApp
//
//  Created by Alumno on 06/10/25.
//

import Foundation
import Combine

final class TranslateViewModel: ObservableObject {
    @Published var countries: [Country] = TranslateViewModel.sampleCountries

    // Tipos
    struct Phrase: Identifiable, Hashable { var id = UUID(); var text: String }
    struct Situation: Identifiable, Hashable { var id = UUID(); var title: String; var phrases: [Phrase] }
    struct Country: Identifiable, Hashable { var id = UUID(); var name: String; var flag: String?; var situations: [Situation] }

    // MARK: - Helpers (ESTÁTICOS)
    private static func situationTitles() -> [String] {
        [
            "Cafetería","Transporte","Alojamiento","Restaurante","Emergencias",
            "Direcciones","Compras","Salud / Farmacia","Banco / Cajero","Internet / Conectividad"
        ]
    }

    private static func packSituations(_ titles: [String], _ pairs: [(String,String)]) -> [Situation] {
        precondition(titles.count == pairs.count, "Debe haber 10 títulos y 10 pares de frases")
        return zip(titles, pairs).map { title, pair in
            Situation(title: title, phrases: [Phrase(text: pair.0), Phrase(text: pair.1)])
        }
    }

    // MARK: - Frases por idioma (ESTÁTICAS)
    private static func frSituations() -> [Situation] {
        let t = situationTitles()
        let p: [(String,String)] = [
            ("Un café, s’il vous plaît.", "Avez-vous du lait végétal ?"),
            ("Où puis-je acheter des tickets de bus ?", "Y a-t-il un train pour Lyon aujourd’hui ?"),
            ("J’ai une réservation au nom de Martínez.", "Avez-vous une chambre pour deux nuits ?"),
            ("Avez-vous des options végétariennes ?", "L’addition, s’il vous plaît."),
            ("J’ai besoin d’aide, pouvez-vous appeler les secours ?", "Où est l’hôpital le plus proche ?"),
            ("Où se trouve cette adresse ?", "Pouvez-vous me montrer sur la carte, s’il vous plaît ?"),
            ("Combien ça coûte ?", "Puis-je payer par carte ?"),
            ("Avez-vous du paracétamol ?", "Je suis allergique à la pénicilline."),
            ("Où est le distributeur le plus proche ?", "Puis-je retirer de l’argent ici ?"),
            ("Quel est le mot de passe du Wi-Fi ?", "Y a-t-il une carte eSIM pour touristes ?")
        ]
        return packSituations(t, p)
    }

    private static func itSituations() -> [Situation] {
        let t = situationTitles()
        let p: [(String,String)] = [
            ("Un caffè, per favore.", "Avete latte vegetale?"),
            ("Dove posso comprare i biglietti dell’autobus?", "C’è un treno per Firenze oggi?"),
            ("Ho una prenotazione a nome Martínez.", "Avete una camera per due notti?"),
            ("Avete opzioni vegetariane?", "Il conto, per favore."),
            ("Ho bisogno di aiuto, potete chiamare i soccorsi?", "Dov’è l’ospedale più vicino?"),
            ("Dov’è questo indirizzo?", "Può indicarmelo sulla mappa?"),
            ("Quanto costa?", "Posso pagare con carta?"),
            ("Avete paracetamol?", "Sono allergico/a alla penicillina."),
            ("Dov’è il bancomat più vicino?", "Posso prelevare qui?"),
            ("Qual è la password del Wi-Fi?", "Avete eSIM per turisti?")
        ]
        return packSituations(t, p)
    }

    private static func deSituations() -> [Situation] {
        let t = situationTitles()
        let p: [(String,String)] = [
            ("Einen Kaffee, bitte.", "Haben Sie Pflanzenmilch?"),
            ("Wo kann ich Bustickets kaufen?", "Gibt es heute einen Zug nach München?"),
            ("Ich habe eine Reservierung auf den Namen Martínez.", "Haben Sie ein Zimmer für zwei Nächte?"),
            ("Haben Sie vegetarische Optionen?", "Die Rechnung, bitte."),
            ("Ich brauche Hilfe, können Sie den Notruf wählen?", "Wo ist das nächste Krankenhaus?"),
            ("Wo befindet sich diese Adresse?", "Können Sie es mir auf der Karte zeigen?"),
            ("Wie viel kostet das?", "Kann ich mit Karte bezahlen?"),
            ("Haben Sie Paracetamol?", "Ich bin allergisch gegen Penicillin."),
            ("Wo ist der nächste Geldautomat?", "Kann ich hier Geld abheben?"),
            ("Wie lautet das WLAN-Passwort?", "Gibt es eine eSIM für Touristen?")
        ]
        return packSituations(t, p)
    }

    private static func jaSituations() -> [Situation] {
        let t = situationTitles()
        let p: [(String,String)] = [
            ("コーヒーをお願いします。", "植物性ミルクはありますか？"),
            ("バスの切符はどこで買えますか？", "今日は大阪行きの電車はありますか？"),
            ("マルティネスの名前で予約しています。", "二泊できる部屋はありますか？"),
            ("ベジタリアンのメニューはありますか？", "お会計をお願いします。"),
            ("助けが必要です。救急車を呼んでください。", "一番近い病院はどこですか？"),
            ("この住所はどこですか？", "地図で教えていただけますか？"),
            ("これはいくらですか？", "カードで支払えますか？"),
            ("パラセタモールはありますか？", "ペニシリンにアレルギーがあります。"),
            ("近くのATMはどこですか？", "ここで現金を引き出せますか？"),
            ("Wi-Fiのパスワードは何ですか？", "観光客向けのeSIMはありますか？")
        ]
        return packSituations(t, p)
    }

    private static func zhSituations() -> [Situation] {
        let t = situationTitles()
        let p: [(String,String)] = [
            ("请给我一杯咖啡。", "有植物奶吗？"),
            ("公交车票在哪里可以买到？", "今天有去上海的火车吗？"),
            ("我以 Martínez 的名字预订了房间。", "有可以住两晚的房间吗？"),
            ("有素食选择吗？", "请结账。"),
            ("我需要帮助，能帮我打急救电话吗？", "最近的医院在哪里？"),
            ("这个地址在哪里？", "可以在地图上给我指一下吗？"),
            ("这个多少钱？", "可以刷卡吗？"),
            ("有对乙酰氨基酚吗？", "我对青霉素过敏。"),
            ("最近的取款机在哪里？", "这里可以取现吗？"),
            ("Wi-Fi 密码是什么？", "有游客用的 eSIM 吗？")
        ]
        return packSituations(t, p)
    }

    private static func ptBrSituations() -> [Situation] {
        let t = situationTitles()
        let p: [(String,String)] = [
            ("Um café, por favor.", "Vocês têm leite vegetal?"),
            ("Onde posso comprar passagens de ônibus?", "Tem trem para São Paulo hoje?"),
            ("Tenho uma reserva no nome Martínez.", "Vocês têm quarto para duas noites?"),
            ("Vocês têm opções vegetarianas?", "A conta, por favor."),
            ("Preciso de ajuda, pode chamar o resgate?", "Onde fica o hospital mais próximo?"),
            ("Onde fica este endereço?", "Pode me mostrar no mapa?"),
            ("Quanto custa?", "Posso pagar com cartão?"),
            ("Tem paracetamol?", "Sou alérgico(a) à penicilina."),
            ("Onde tem um caixa eletrônico?", "Posso sacar dinheiro aqui?"),
            ("Qual é a senha do Wi-Fi?", "Tem eSIM para turistas?")
        ]
        return packSituations(t, p)
    }

    private static func trSituations() -> [Situation] {
        let t = situationTitles()
        let p: [(String,String)] = [
            ("Bir kahve lütfen.", "Bitkisel süt var mı?"),
            ("Otobüs bileti nereden alabilirim?", "Bugün Ankara’ya tren var mı?"),
            ("Martínez adına bir rezervasyonum var.", "İki gece için oda var mı?"),
            ("Vejetaryen seçenekleriniz var mı?", "Hesabı alabilir miyim?"),
            ("Yardıma ihtiyacım var, acili arar mısınız?", "En yakın hastane nerede?"),
            ("Bu adres nerede?", "Haritada gösterebilir misiniz?"),
            ("Bu ne kadar?", "Kartla ödeyebilir miyim?"),
            ("Parasetamol var mı?", "Penisiline alerjim var."),
            ("En yakın ATM nerede?", "Buradan para çekebilir miyim?"),
            ("Wi-Fi şifresi nedir?", "Turistler için eSIM var mı?")
        ]
        return packSituations(t, p)
    }

    private static func arEgSituations() -> [Situation] {
        let t = situationTitles()
        let p: [(String,String)] = [
            ("من فضلك قهوة.", "هل لديكم حليب نباتي؟"),
            ("أين يمكنني شراء تذاكر الحافلة؟", "هل يوجد قطار إلى الإسكندرية اليوم؟"),
            ("لدي حجز باسم مارتينيز.", "هل توجد غرفة لليلتين؟"),
            ("هل لديكم خيارات نباتية؟", "من فضلك الحساب."),
            ("أحتاج إلى مساعدة، هل يمكنك الاتصال بالإسعاف؟", "أين أقرب مستشفى؟"),
            ("أين يقع هذا العنوان؟", "هل يمكنك أن تشير إليه على الخريطة؟"),
            ("بكم هذا؟", "هل يمكنني الدفع بالبطاقة؟"),
            ("هل لديكم باراسيتامول؟", "أنا لدي حساسية من البنسلين."),
            ("أين أقرب صراف آلي؟", "هل يمكنني السحب من هنا؟"),
            ("ما هي كلمة مرور الواي فاي؟", "هل توجد eSIM للسياح؟")
        ]
        return packSituations(t, p)
    }

    private static func hiSituations() -> [Situation] {
        let t = situationTitles()
        let p: [(String,String)] = [
            ("एक कॉफ़ी दीजिए।", "क्या आपके पास प्लांट-बेस्ड दूध है?"),
            ("बस का टिकट कहाँ मिलेगा?", "क्या आज आगरा के लिए ट्रेन है?"),
            ("मेरे नाम (मार्टिनेज) से बुकिंग है।", "क्या दो रात के लिए कमरा मिलेगा?"),
            ("क्या शाकाहारी विकल्प हैं?", "बिल दीजिए, कृपया।"),
            ("मुझे मदद चाहिए, कृपया एम्बुलेंस बुलाइए।", "सबसे नज़दीकी अस्पताल कहाँ है?"),
            ("यह पता कहाँ है?", "क्या आप नक्शे पर दिखा सकते हैं?"),
            ("यह कितने का है?", "क्या कार्ड से भुगतान कर सकता/सकती हूँ?"),
            ("क्या आपके पास पेरासिटामोल है?", "मुझे पेनिसिलिन से एलर्जी है।"),
            ("नज़दीकी एटीएम कहाँ है?", "क्या यहाँ नकदी निकाली जा सकती है?"),
            ("वाई-फाई का पासवर्ड क्या है?", "क्या पर्यटकों के लिए eSIM मिलती है?")
        ]
        return packSituations(t, p)
    }

    private static func enGbSituations() -> [Situation] {
        let t = situationTitles()
        let p: [(String,String)] = [
            ("A coffee, please.", "Do you have plant-based milk?"),
            ("Where can I buy bus tickets?", "Is there a train to Manchester today?"),
            ("I have a reservation under Martínez.", "Do you have a room for two nights?"),
            ("Do you have vegetarian options?", "The bill, please."),
            ("I need help, could you call emergency services?", "Where’s the nearest hospital?"),
            ("Where is this address?", "Could you show me on the map?"),
            ("How much is this?", "Can I pay by card?"),
            ("Do you have paracetamol?", "I’m allergic to penicillin."),
            ("Where’s the nearest cash machine?", "Can I withdraw money here?"),
            ("What’s the Wi-Fi password?", "Do you have a tourist eSIM?")
        ]
        return packSituations(t, p)
    }

    // MARK: - Data estático (ESTÁTICO)
    static let sampleCountries: [Country] = [
        Country(name: "Francia (París, francés)",   flag: "🇫🇷", situations: frSituations()),
        Country(name: "Italia (Roma, italiano)",    flag: "🇮🇹", situations: itSituations()),
        Country(name: "Alemania (Berlín, alemán)",  flag: "🇩🇪", situations: deSituations()),
        Country(name: "Japón (Tokio, japonés)",     flag: "🇯🇵", situations: jaSituations()),
        Country(name: "China (Pekín, mandarín)",    flag: "🇨🇳", situations: zhSituations()),
        Country(name: "Brasil (Río, portugués)",    flag: "🇧🇷", situations: ptBrSituations()),
        Country(name: "Turquía (Estambul, turco)",  flag: "🇹🇷", situations: trSituations()),
        Country(name: "Egipto (El Cairo, árabe)",   flag: "🇪🇬", situations: arEgSituations()),
        Country(name: "India (Delhi, hindi)",       flag: "🇮🇳", situations: hiSituations()),
        Country(name: "Reino Unido (Londres, inglés)", flag: "🇬🇧", situations: enGbSituations())
    ]
}
