# RGB controller app

Patryk Saj (313449)

## Dokumentacja końcowa

Aplikacja docelowo ma służyc do kontroli taśm/lamp LED, gdzie za komunikację i sterowanie będzie odpowiadać układ ESP8266 z odpowiednim oprogramowaniem.
Funkcjonalność komunikacji z urządzeniami została zasymulowana celem zaprezentowania sposobu działania aplikacji.
Aplikacja składa się z 4 głównych paneli: wybór urządzeń do współpracy, ustawienie stałego koloru, ustawienie sekwencji oraz świecenie w rytm wskazanego utwóru.
Przełączenie się między panelami odbywa się poprzez nawigację menu na dole ekranu. Pokrótce omówię każdy z paneli:
1. Panel wyboru urządzeń do kontroli: 
	Jest to panel ukazywany użytkownikowi podczas uruchomienia aplikacji. Na górze pokazany jest element z zawartym komunikatem o ilości podłączonych urządzeń.
	Aby połączyć się z nowym urządzeniem, użytkownik musi wyszukać urządznia dostępne na jego lokalnej sieci, a następnie wybrać te adresy IP, które korespondują z urządzeniami, którymi chce sterować. Kluczowa jest inicjalizacja połączenia z przynajmniej jednym urządzeniem - brak urządzeń nie pozowli użytkownikowi na korzystanie z pełni funkcjonalności aplikacji.
2. Panel ustawienia koloru stałego:
	Jest to panel umieszczony skrajnie po lewej na pasku menu. Uzytkownik może tutaj wybrać kolor za pomocą huewheel i innych mu pochodnych lub manualnie wpisać kod wybranego koloru. Po dokonaniu wyboru, użytkownik przyciskiem na dole ekranu zatwierdza zmianę i przekazuje informacje urządzeniom. Zmiana statusu zostanie odzwierciedlona w elemencie reprezentującym stan na górze ekranu.
3. Panel tworzenia sekwencji:
	Jest to panel drugi od lewej. Tutaj użytkownik może stworzyć sekwencję zmian między światłem białym i jego brakiem. Tworzenie odbywa się za pomocą tworzenia naprzemiennie kolejnych elementów sekwencji, nadając im długość w milisekundach (pole z walidacją). Kolejno tworzone elementy są odzwierciedlane poniżej.
	Pod wizualizacją tworzonej sekwencji znajduję się przycisk do usunięcięcia postępu i ew. zaczęcia tworzenia sekwencji od nowa. Na dole panelu znajduje się przycisk służący zatwierdzeniu zmian. Przycisk nie zadziała, gdy stworzona sekwencja jest pusta - status urządzeń nie zostanie zmieniony. Zmiana statusu zostanie odzwierciedlona w elemencie reprezentującym stan na górze ekranu.
4. Panel świecenia do muzyki:
	Jest to panel drugi do prawej. Użytkownik ma domyślnie dostępne pole do podania wartości BPM (ang. Beats Per Minute), z którą będą migać światła. Jest to tak na prawdę opcja zastępcza w wypadku, gdyby użytkownik nie miał stałego połączenia z intenetem, lecz jest sama w sobie pełnoprawną funkcjonalnością. Poniżej tego fragmentu, znajduje się przycisk służący do testowania połączenia z internetem - jeśli takowe zostanie znalezione, użytkownik odblokuje możliwości korzystania z automatycznego wyszukiwania wartości BPM ulubionego utworu. Zostanie udostępnione pole tekstowe, w którym użytkownik powienien wpisać nazwę utworu i autora. Następnie, przy pomocy bazy utowrów dostępnych na platformie Spotify, poniżej pola wyszukiwania zostanie pokazany rezulat wyszukania: okładka albumu utworu, nazwa, autor, nazwa albumu oraz odpowiadająca utworowi wartość BPM. Jeśli użytkownik jest zadowolny z uzyskanego rezultatu wyszukiwania, może zaakceptować je, przesyłając je do urządzenia lub zmodyfikować podane wcześniej hasło wyszukiwania i spróbować ponownie. Zmiana statusu zostanie odzwierciedlona w elemencie reprezentującym stan na górze ekranu.
	
Integracja aplikacji:
	Aplikacja została stworzona i przetestowana pod platformę Android, działania jej na innych platformach nie jest w 100% poprawne (ma to związek z tym, jak każda platforma na swój własny sposób zapewnia dostęp do sieci lokalniej urządzenia). 
	Aplikacja nie wymaga od użytkownika tworzenia konta oraz logowania się, co jest sprzeczne z obecnymi trendami wymuszania od użytkownika stałego dostępu do sieci i posiadania konta, mimo, że natura aplikacji tego nie wymaga. 
	Aplikacja posiada integracje z dwoma zewnętrznymi API: 'spotify23.p.rapidapi.com' ORAZ 'api.spotify.com'. Potrzeba korzystania z zewnętrzego API będącego nakładką na API plaformy Spotify wynika z błędu w implementacji/dokumentacji tegoż API (mimo explicite wskazania, że oczekujemy odpowiedzi w postaci Utworów, API Spotify z premedytacją zwracało Albumy).
	
Lista opcjonalnych wymagań:
	Tak jak było to zaznaczone w pierwszym akapicie opisującym aplikacje, aplikacja do działania nie potrzebuje niczego, jednak jej funkcjonalności będą ograniczone. Połączenie sie z internetem zapewni dostęp do łatwego znalezienia wartości BPM wybranej piosenki. Urządzenia do sterowania na tej samej sieci lokalnej co urządzenie z aplikacją odblokuje możliwość połączenia się z takowymi i wysyłania do nich poleceń (próba wysłania polecenia bez wybranego choć jednego urządzenia zakończy się pokazaniem stosownego komunikatu błędu i przerwaniem czynności.
	
Instrukcja:
	Sposób posługiwania się aplikacją został kompleksowo pokryty w pierwszym akapicie. Aplikacja jest zrobiona z minimalizmem na myśli, a jednorodna i kontrastowa szata graficzna pozwala bez problemu odnaleźć się w UI.
	
[CI/CD](vercel.png)
	

## Dokumentacja wstępna

Apka - kontroler do LEDów:

Ficzery (zawarte w menu):
- Wybór urządzeń do kontroli:
	=> Wysitowane urządzenia wykryte w połączonej sieci Wi-Fi (nazwa, lokalne IP)
	=> Zaznaczenie symbolem/kolorem obsługowanych urządzeń
	=> Kliknięciem wybierasz urządzenia, którymi chcesz sterować (zaznaczają się, można wiele)
	!  Dummy - przykładowa lista urządzeń, fukcjonalność zachowana
- Huewheel:
	=> Naciskasz w huewheel aby wybrać kolor
	=> Niżej pole z podglądem wybranego koloru
	=> Obok pola, suwak do ustawienia jasności
	=> Na dole guzik do przesłania do urządzenia polecenia
- Sekwencje:
	=> Do wyboru kilka podstawowych kolorów/OFF
	=> Użytkownik wybiera kolor, czas trwania (w ms) i dodaje do sekwencji
	=> Na górze aktualizowana lista kolejnych elementów sekwencji, można usuwać dodane elementy
	=> Na dole guzik do przesłania do urządzenia polecenia
	*  Możliwość zapisu/wczytania sekwencji z urządzenia
- Synchronizacja do muzyki (via. Spotify API):
	=> Pole do wpisania tytułu piosenki
	=> API zwraca pasujące utwory, apka wyświetla listę: tytuł, wykonawca(-y), okładka
	=> Użytkownik klika w wybraną piosenkę, piosenka wyświetla się na dole jako ta "wybrana"
	=> Na dole guzik do przesłania do urządzenia polecenia

Na górze pasek z wybraną liczbą urządzeń, i obecnym stanem (OFF / Solid Color / Sequence / Music)