package Beans;

public class AutomobilBean {
    private Integer id;
    private String marka;
    private String model;
    private String menjac;
    private String gorivo;
    private String karoserija;
    private String pogon;
    private String zemlja;

    public AutomobilBean() {
    }

    public AutomobilBean(Integer id, String marka, String model, String menjac, String gorivo, String karoserija, String pogon, String zemlja) {
        this.id = id;
        this.marka = marka;
        this.model = model;
        this.menjac = menjac;
        this.gorivo = gorivo;
        this.karoserija = karoserija;
        this.pogon = pogon;
        this.zemlja = zemlja;
    }

    public Integer getId() {
        return id;
    }

    public void setId(Integer id) {
        this.id = id;
    }

    public String getMarka() {
        return marka;
    }

    public void setMarka(String marka) {
        this.marka = marka;
    }

    public String getModel() {
        return model;
    }

    public void setModel(String model) {
        this.model = model;
    }

    public String getMenjac() {
        return menjac;
    }

    public void setMenjac(String menjac) {
        this.menjac = menjac;
    }

    public String getGorivo() {
        return gorivo;
    }

    public void setGorivo(String gorivo) {
        this.gorivo = gorivo;
    }

    public String getZemlja() {
        return zemlja;
    }

    public void setZemlja(String zemlja) {
        this.zemlja = zemlja;
    }

    public String getPogon() {
        return pogon;
    }

    public void setPogon(String pogon) {
        this.pogon = pogon;
    }

    public String getKaroserija() {
        return karoserija;
    }

    public void setKaroserija(String karoserija) {
        this.karoserija = karoserija;
    }
}