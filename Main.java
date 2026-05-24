import java.sql.*;
import java.util.Scanner;

public class Main {
    private static final String URL = "jdbc:mysql://localhost:3306/catcafe";
    private static final String USER = "user";
    private static final String PASSWORD = "gattomatto";

    public static void main(String[] args) {
        Scanner scanner = new Scanner(System.in);
        boolean quit = false;

        while (!quit) {
            System.out.println("Cosa vuoi fare?");
            System.out.println("1. Visualizza la situazione dei tavoli");
            System.out.println("2. Visualizza l'elenco dei gatti in sala");
            System.out.println("3. Visualizza lo storico degli scontrini");
            System.out.println("4. Modifica lo stato di un tavolo");
            System.out.println("5. Esci dall'applicazione");
            System.out.print("> ");

            int scelta = scanner.nextInt();

            if (scelta == 1) {
                visualizzaTavoli();
            } else if (scelta == 2) {
                visualizzaGattiInSala();
            } else if (scelta == 3) {
                visualizzaStoricoScontrini();
            } else if (scelta == 4) {
                cambiaStatoTavolo(scanner);
            } else if (scelta == 5) {
                quit = true;
            } else {
                System.out.println("Opzione non valida");
            }
            System.out.println();
        }
        scanner.close();
    }

    private static void visualizzaTavoli() {
        String query = "SELECT NumeroTavolo, Capacità, Stato FROM Tavolo";
        try (Connection conn = DriverManager.getConnection(URL, USER, PASSWORD);
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(query)) {

            System.out.println("Situazione tavoli");
            while (rs.next()) {
                int numero = rs.getInt("NumeroTavolo");
                int capacita = rs.getInt("Capacità");
                boolean occupato = rs.getBoolean("Stato");
                String statoTavolo = occupato ? "Libero" : "Occupato";

                System.out.println("Tavolo " + numero + " (" + capacita + " posti): " + statoTavolo);
            }
        } catch (SQLException e) {
            System.out.println("Errore." + e.getMessage());
        }
    }

    private static void visualizzaGattiInSala() {
        String query = "SELECT nome, razza, informazioni FROM vistaGatti";

        try (Connection conn = DriverManager.getConnection(URL, USER, PASSWORD);
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(query)) {
            boolean noCat = true;

            System.out.println("I gatti attualmente in sala sono: ");
            while (rs.next()) {
                noCat = false;
                String nome = rs.getString("nome");
                String razza = rs.getString("razza");
                String informazioni = rs.getString("informazioni");
                System.out.println("- " + nome + " (" + razza + "): " + informazioni);
            }

            if (noCat) {
                System.out.println("Al momento non ci sono gatti in sala.");
            }
        } catch (SQLException e) {
            System.out.println("Errore. " + e.getMessage());
        }
    }

    private static void visualizzaStoricoScontrini() {
        String query = "SELECT IDScontrino, totale, timestamp, prodotto, quantità, prezzoUnitario FROM storicoScontrini";

        try (Connection conn = DriverManager.getConnection(URL, USER, PASSWORD);
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(query)) {
            int ultimoId = -1;
            boolean noData = true;

            System.out.println("Storico degli scontrini:");
            while (rs.next()) {
                noData = false;
                int idAttuale = rs.getInt("IDScontrino");
                if (idAttuale != ultimoId) {
                    System.out.println();
                    double totale = rs.getDouble("totale");
                    Timestamp ts = rs.getTimestamp("timestamp");
                    System.out.printf("Scontrino: %d ", idAttuale);
                    System.out.printf("(%s)\n", ts.toString());
                    System.out.printf("Totale: %.2f€\n", totale);
                    System.out.println("Prodotti ordinati:");
                    ultimoId = idAttuale;
                }
                int idProdotto = rs.getInt("prodotto");
                int quantita = rs.getInt("quantità");
                double prezzoU = rs.getDouble("prezzoUnitario");
                System.out.printf("- ID: %02d | Qtà: %-2d x  Prezzo: %3.2f€\n", idProdotto, quantita, prezzoU);
            }

            if (noData) {
                System.out.println("Lo storico scontrini è vuoto.");
            }
        } catch (SQLException e) {
            System.out.println("Errore " + e.getMessage());
        }
    }

    private static void cambiaStatoTavolo(Scanner scanner) {
        System.out.print("Inserisci il numero del tavolo da modificare: ");
        int numTavolo = scanner.nextInt();
        scanner.nextLine();

        System.out.print("Imposta il nuovo stato (libero o occupato): ");
        String nuovoStato = scanner.nextLine();

        boolean nuovostatoBoolean;
        if(nuovoStato.equalsIgnoreCase("libero")){
            nuovostatoBoolean = true;
        } else if (nuovoStato.equalsIgnoreCase("occupato")) {
            nuovostatoBoolean = false;
        }
        else {
            System.out.println("Lo stato inserito non è valido.");
            return;
        }

        String query = "UPDATE Tavolo SET Stato = ? WHERE NumeroTavolo = ?";
        try (
                Connection conn = DriverManager.getConnection(URL, USER, PASSWORD);
                PreparedStatement pstmt = conn.prepareStatement(query)) {

            pstmt.setBoolean(1, nuovostatoBoolean);
            pstmt.setInt(2, numTavolo);

            int righeCoinvolte = pstmt.executeUpdate();
            if (righeCoinvolte > 0) {
                System.out.println("Lo stato del tavolo " + numTavolo + " è stato aggiornato.");
            } else {
                System.out.println("Modifica non eseguita. Il tavolo" + numTavolo + "non è stato trovato.");
            }
        } catch (
                SQLException e) {
            System.out.println("Errore " + e.getMessage());
        }
    }
}