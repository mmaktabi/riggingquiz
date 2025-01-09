import 'package:flutter/material.dart';
import 'package:rigging_quiz/utils/layout.dart';

class PrivacyPolicyPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return QLayout(
      child: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionTitle('Verantwortlicher'),
            _buildParagraph(
                'Verantwortlicher im Sinne der Datenschutzgesetze, insbesondere der EU-Datenschutz-Grundverordnung (DSGVO), ist:'),
            _buildParagraph(
                'Sabine Hößel\nSchweinfurter Str. 28\n97076 Würzburg\nGermany'),
            _buildSectionTitle('Ihre Betroffenenrechte'),
            _buildParagraph(
                'Unter den angegebenen Kontaktdaten können Sie gemäß EU-Datenschutz-Grundverordnung (DSGVO) jederzeit folgende Rechte ausüben:'),
            _buildList([
              'Auskunft über Ihre bei uns gespeicherten Daten und deren Verarbeitung (Art. 15 DSGVO)',
              'Berichtigung unrichtiger personenbezogener Daten (Art. 16 DSGVO)',
              'Löschung Ihrer bei uns gespeicherten Daten (Art. 17 DSGVO)',
              'Einschränkung der Datenverarbeitung, sofern wir Ihre Daten aufgrund gesetzlicher Pflichten noch nicht löschen dürfen (Art. 18 DSGVO)',
              'Widerspruch gegen die Verarbeitung Ihrer Daten bei uns (Art. 21 DSGVO)',
              'Datenübertragbarkeit, sofern Sie in die Datenverarbeitung eingewilligt haben oder einen Vertrag mit uns abgeschlossen haben (Art. 20 DSGVO)',
            ]),
            _buildParagraph(
                'Sofern Sie uns eine Einwilligung erteilt haben, können Sie diese jederzeit mit Wirkung für die Zukunft widerrufen.'),
            _buildParagraph(
                'Sie können sich jederzeit mit einer Beschwerde an eine Aufsichtsbehörde wenden, z. B. an die zuständige Aufsichtsbehörde des Bundeslands Ihres Wohnsitzes oder an die für uns als verantwortliche Stelle zuständige Behörde.'),
            _buildParagraph(
                'Eine Liste der Aufsichtsbehörden (für den nichtöffentlichen Bereich) mit Anschrift finden Sie unter:'),
            _buildLink('https://www.bfdi.bund.de/DE/Infothek/Anschriften_Links/anschriften_links-node.html'),
            _buildSectionTitle('Verarbeitungstätigkeiten'),
            _buildSubsectionTitle('Erfassung allgemeiner Informationen beim Besuch unserer Website'),
            _buildSubsectionContent(
                'Wenn Sie auf unsere Website zugreifen, d.h., wenn Sie sich nicht registrieren oder anderweitig Informationen übermitteln, werden automatisch Informationen allgemeiner Natur erfasst. Diese Informationen (Server-Logfiles) beinhalten etwa die Art des Webbrowsers, das verwendete Betriebssystem, den Domainnamen Ihres Internet-Service-Providers, Ihre IP-Adresse und ähnliches.'),
            _buildParagraph(
                'Sie werden insbesondere zu folgenden Zwecken verarbeitet:'),
            _buildList(['Sicherstellung einer reibungslosen Nutzung der Website']),
            _buildParagraph(
                'Wir verwenden Ihre Daten nicht, um Rückschlüsse auf Ihre Person zu ziehen. Allerdings behalten wir uns vor, die Server-Logfiles nachträglich zu überprüfen, sollten konkrete Anhaltspunkte auf eine rechtswidrige Nutzung hinweisen.'),
            _buildSubsectionTitle('Rechtsgrundlage und berechtigtes Interesse'),
            _buildParagraph(
                'Die Verarbeitung erfolgt gemäß Art. 6 Abs. 1 lit. f DSGVO auf Basis unseres berechtigten Interesses an der Verbesserung der Stabilität und Funktionalität unserer Website sowie der Sicherstellung der Systemsicherheit und Missbrauchserkennung.'),
            _buildSubsectionTitle('Empfänger'),
            _buildParagraph(
                'Empfänger der Daten sind ggf. technische Dienstleister, die für den Betrieb und die Wartung unserer Webseite als Auftragsverarbeiter tätig werden.'),
            _buildSubsectionTitle('Speicherdauer'),
            _buildParagraph(
                'Daten werden in Server-Log-Dateien in einer Form, die die Identifizierung der betroffenen Personen ermöglicht, maximal für 14 Tage gespeichert; es sei denn, dass ein sicherheitsrelevantes Ereignis auftritt (z.B. ein DDoS-Angriff).'),
            _buildSubsectionTitle('Bereitstellung vorgeschrieben oder erforderlich'),
            _buildParagraph(
                'Die Bereitstellung der vorgenannten personenbezogenen Daten ist weder gesetzlich noch vertraglich vorgeschrieben. Ohne die IP-Adresse ist jedoch der Dienst und die Funktionsfähigkeit unserer Website nicht gewährleistet. Zudem können einzelne Dienste und Services nicht verfügbar oder eingeschränkt sein.'),
            _buildSubsectionTitle('Widerspruch'),
            _buildParagraph(
                'Lesen Sie dazu die Informationen über Ihr Widerspruchsrecht nach Art. 21 DSGVO weiter unten.'),
            _buildSectionTitle('Kontaktaufnahme'),
            _buildParagraph(
                'Art und Zweck der Verarbeitung'),
            _buildParagraph(
                'Auf unserer Website ist ein Kontaktformular vorhanden, welches für die elektronische Kontaktaufnahme genutzt werden kann. Nimmt ein Nutzer diese Möglichkeit wahr, so werden die in der Eingabemaske eingegeben Daten an uns übermittelt und gespeichert.'),
            _buildParagraph(
                'Zum Zeitpunkt der Absendung der Nachricht werden zudem folgende Daten gespeichert:'),
            _buildList(['Datum und Uhrzeit der Anfrage']),
            _buildParagraph(
                'Eine Kontaktaufnahme ist über die bereitgestellten E-Mail-Adressen möglich. In diesem Fall werden die mit der E-Mail übermittelten personenbezogenen Daten des Nutzers gespeichert.'),
            _buildSubsectionTitle('Rechtsgrundlage'),
            _buildParagraph(
                'Die Verarbeitung der Daten erfolgt auf der Grundlage eines berechtigten Interesses (Art. 6 Abs. 1 lit. f DSGVO).'),
            _buildParagraph(
                'Unser berechtigtes Interesse an der Verarbeitung Ihrer Daten ist die Ermöglichung einer unkomplizierten Kontaktaufnahme.'),
            _buildSubsectionTitle('Empfänger'),
            _buildParagraph(
                'Empfänger der Daten sind ggf. technische Dienstleister, die für den Betrieb und die Wartung unserer Webseite als Auftragsverarbeiter tätig werden.'),
            _buildSubsectionTitle('Speicherdauer'),
            _buildParagraph(
                'Daten werden spätestens [Bitte Informationen ergänzen] nach Bearbeitung der Kontaktaufnahme gelöscht.'),
            _buildSubsectionTitle('Bereitstellung vorgeschrieben oder erforderlich'),
            _buildParagraph(
                'Die Bereitstellung Ihrer personenbezogenen Daten erfolgt freiwillig. Wir können Ihre Anfrage jedoch nur bearbeiten, sofern Sie uns die erforderlichen Daten und den Grund der Anfrage mitteilen.'),
            _buildSectionTitle('Newsletter'),
            _buildParagraph('Art und Zweck der Verarbeitung'),
            _buildParagraph(
                'Für die Zustellung unseres Newsletters bzw. vergleichbarer Informationen erheben wir personenbezogene Daten, die über eine Eingabemaske an uns übermittelt werden.'),
            _buildParagraph(
                'Für eine wirksame Registrierung benötigen wir eine valide E-Mail-Adresse. Um zu überprüfen, dass eine Anmeldung tatsächlich durch den Inhaber einer E-Mail-Adresse erfolgt, setzen wir das Double-Opt-in-Verfahren ein.'),
            _buildSubsectionTitle('Rechtsgrundlage'),
            _buildParagraph(
                'Auf Grundlage Ihrer ausdrücklich erteilten Einwilligung (Art. 6 Abs. 1 lit. a DSGVO), übersenden wir Ihnen regelmäßig unseren Newsletter bzw. vergleichbare Informationen per E-Mail an Ihre angegebene E-Mail-Adresse.'),
            _buildSubsectionTitle('Empfänger'),
            _buildParagraph(
                'Wir setzen für den Versand einen Dienstleister ein, der als unser Auftragsverarbeiter tätig wird.'),
            _buildSubsectionTitle('Speicherdauer'),
            _buildParagraph(
                'Die Daten werden in diesem Zusammenhang nur verarbeitet, solange die entsprechende Einwilligung vorliegt.'),
            _buildSubsectionTitle('Bereitstellung vorgeschrieben oder erforderlich'),
            _buildParagraph(
                'Die Bereitstellung Ihrer personenbezogenen Daten erfolgt freiwillig, allein auf Basis Ihrer Einwilligung. Ohne bestehende Einwilligung können wir Ihnen unseren Newsletter nicht zusenden.'),
            _buildSubsectionTitle('Widerruf der Einwilligung'),
            _buildParagraph(
                'Die Einwilligung zur Speicherung Ihrer persönlichen Daten und ihrer Nutzung für den Newsletterversand können Sie jederzeit mit Wirkung für die Zukunft widerrufen.'),
            _buildSectionTitle('Social Plugin (Shariff)'),
            _buildParagraph(
                'Auf unserer Website nutzen wir ein Social Plugin, um das Teilen bei den unten aufgeführten Social-Media-Angeboten bzw. Anbietern zu vereinfachen.'),
            _buildSectionTitle('Verwendung des Tracking-Tools Google Analytics'),
            _buildSubsectionTitle('Art und Zweck der Verarbeitung'),
            _buildParagraph(
                'Soweit Sie Ihre Einwilligung erteilt haben, wird auf dieser Website Google Analytics 4 eingesetzt, ein Webanalysedienst der Google Ireland Limited (Google Building Gordon House, 4 Barrow St, Dublin, D04 E5W5, Irland).'),
            _buildSubsectionTitle('Rechtsgrundlage'),
            _buildParagraph(
                'Rechtsgrundlage für diese Datenverarbeitung ist Ihre Einwilligung gem. Art.6 Abs.1 S.1 lit.a DSGVO.'),
            _buildSubsectionTitle('Empfänger'),
            _buildParagraph(
                'Wir setzen für Betrieb und Wartung unserer Webseite und für die Auswertung der Cookies technische Dienstleister ein, die als unsere Auftragsverarbeiter tätig werden.'),
            _buildSubsectionTitle('Speicherdauer'),
            _buildParagraph('Die von uns gesendeten und mit Cookies verknüpften Daten werden nach automatisch gelöscht nach: 12 Monate.'),
            _buildSectionTitle('Cookies'),
            _buildParagraph(
                'Ein Cookie ist ein kleiner Datensatz, der beim Besuch einer Website erstellt und auf dem System Websitebesuchers zwischengespeichert wird.'),
            _buildSubsectionTitle('Löschen von Cookies'),
            _buildList([
              'Mozilla Firefox: https://support.mozilla.org/de/kb/cookies-loeschen-daten-von-websites-entfernen',
              'Microsoft Edge: https://support.microsoft.com/de-de/windows/verwalten-von-cookies-in-microsoft-edge-anzeigen-zulassen-blockieren-l%C3%B6schen-und-verwenden-168dab11-0753-043d-7c16-ede5947fc64d',
              'Google Chrome: https://support.google.com/accounts/answer/61416?hl=de',
              'Opera: http://www.opera.com/de/help',
              'Safari: https://support.apple.com/kb/PH17191?locale=de_DE&viewlocale=de_DE',
            ]),
            _buildSectionTitle('Technisch notwendige Cookies'),
            _buildSubsectionTitle('Art und Zweck der Verarbeitung'),
            _buildParagraph(
                'Wir setzen Cookies ein, um unsere Website nutzerfreundlicher zu gestalten. Einige Elemente unserer Website erfordern es, dass der aufrufende Browser auch nach einem Seitenwechsel identifiziert werden kann.'),
            _buildSubsectionTitle('Rechtsgrundlage und berechtigtes Interesse'),
            _buildParagraph(
                'Die Datenverarbeitung erfolgt insoweit allein auf Basis unseres berechtigten Interesses an einer nutzerfreundlichen Gestaltung unserer Website und an der Dokumentation der Einwilligung gem. Art. 6 Abs. 1 lit. f DSGVO in Verbindung mit einer Abwägung nach §25 Abs. 2 TDDDG.'),
            _buildSectionTitle('Widerruf der Einwilligung'),
            _buildParagraph(
                'Sie können Ihre Einwilligung im Cookie-Consent-Tool für die Zukunft widerrufen.'),
            _buildSectionTitle('Profiling'),
            _buildParagraph(
                'Mit Hilfe technisch nicht notwendiger Cookies können das Verhalten der Websitebesucher bewertet und die Interessen analysiert werden. Hierzu erstellen wir ein pseudonymes Nutzerprofil.'),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(top: 16.0, bottom: 8.0),
      child: Text(
        title,
        style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildSubsectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(top: 16.0, bottom: 8.0),
      child: Text(
        title,
        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildSubsectionContent(String content) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Text(content),
    );
  }

  Widget _buildParagraph(String content) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Text(content),
    );
  }

  Widget _buildList(List<String> items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: items
          .map((item) => Padding(
        padding: const EdgeInsets.only(bottom: 8.0),
        child: Text('• $item'),
      ))
          .toList(),
    );
  }

  Widget _buildLink(String url) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: GestureDetector(
        onTap: () {
          // Hier können Sie Logik hinzufügen, um den Link zu öffnen
        },
        child: Text(
          url,
          style: TextStyle(color: Colors.blue),
        ),
      ),
    );
  }
}
