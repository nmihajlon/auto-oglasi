package Beans;

import java.io.Serializable;

public class PretragaBean implements Serializable {
    private String marka;
    private String model;
    private String gorivo;
    private String pogon;
    private String menjac;
    private String zemlja;
    private String karoserija;
    private Integer kwOd;
    private Integer kwDo;
    private Double ksOd;
    private Double ksDo;
    private Integer kilometrazaOd;
    private Integer kilometrazaDo;
    private Integer godisteOd;
    private Integer godisteDo;
    private Integer cenaMin;
    private Integer cenaMax;
    private String bojaVozila;
    private String vrstaGoriva;

    public PretragaBean(){}

    public PretragaBean(String marka, String model, String gorivo, String pogon, String menjac, String zemlja, String karoserija, Integer kwOd, Integer kwDo, Double ksOd, Double ksDo, Integer kilometrazaOd, Integer kilometrazaDo, Integer godisteOd, Integer godisteDo, Integer cenaMin, Integer cenaMax, String bojaVozila, String vrstaGoriva) {
        this.marka = marka;
        this.model = model;
        this.gorivo = gorivo;
        this.pogon = pogon;
        this.menjac = menjac;
        this.zemlja = zemlja;
        this.karoserija = karoserija;
        this.kwOd = kwOd;
        this.kwDo = kwDo;
        this.ksOd = ksOd;
        this.ksDo = ksDo;
        this.kilometrazaOd = kilometrazaOd;
        this.kilometrazaDo = kilometrazaDo;
        this.godisteOd = godisteOd;
        this.godisteDo = godisteDo;
        this.cenaMin = cenaMin;
        this.cenaMax = cenaMax;
        this.bojaVozila = bojaVozila;
        this.vrstaGoriva = vrstaGoriva;
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

    public String getGorivo() {
        return gorivo;
    }

    public void setGorivo(String gorivo) {
        this.gorivo = gorivo;
    }

    public String getPogon() {
        return pogon;
    }

    public void setPogon(String pogon) {
        this.pogon = pogon;
    }

    public String getMenjac() {
        return menjac;
    }

    public void setMenjac(String menjac) {
        this.menjac = menjac;
    }

    public String getZemlja() {
        return zemlja;
    }

    public void setZemlja(String zemlja) {
        this.zemlja = zemlja;
    }

    public String getKaroserija() {
        return karoserija;
    }

    public void setKaroserija(String karoserija) {
        this.karoserija = karoserija;
    }

    public Integer getKwOd() {
        return kwOd;
    }

    public void setKwOd(Integer kwOd) {
        this.kwOd = kwOd;
    }

    public Integer getKwDo() {
        return kwDo;
    }

    public void setKwDo(Integer kwDo) {
        this.kwDo = kwDo;
    }

    public Double getKsOd() {
        return ksOd;
    }

    public void setKsOd(Double ksOd) {
        this.ksOd = ksOd;
    }

    public Double getKsDo() {
        return ksDo;
    }

    public void setKsDo(Double ksDo) {
        this.ksDo = ksDo;
    }

    public Integer getKilometrazaOd() {
        return kilometrazaOd;
    }

    public void setKilometrazaOd(Integer kilometrazaOd) {
        this.kilometrazaOd = kilometrazaOd;
    }

    public Integer getKilometrazaDo() {
        return kilometrazaDo;
    }

    public void setKilometrazaDo(Integer kilometrazaDo) {
        this.kilometrazaDo = kilometrazaDo;
    }

    public Integer getGodisteOd() {
        return godisteOd;
    }

    public void setGodisteOd(Integer godisteOd) {
        this.godisteOd = godisteOd;
    }

    public Integer getGodisteDo() {
        return godisteDo;
    }

    public void setGodisteDo(Integer godisteDo) {
        this.godisteDo = godisteDo;
    }

    public Integer getCenaMin() {
        return cenaMin;
    }

    public void setCenaMin(Integer cenaMin) {
        this.cenaMin = cenaMin;
    }

    public Integer getCenaMax() {
        return cenaMax;
    }

    public void setCenaMax(Integer cenaMax) {
        this.cenaMax = cenaMax;
    }

    public String getBojaVozila() {
        return bojaVozila;
    }

    public void setBojaVozila(String bojaVozila) {
        this.bojaVozila = bojaVozila;
    }

    public String getVrstaGoriva() {
        return vrstaGoriva;
    }

    public void setVrstaGoriva(String vrstaGoriva) {
        this.vrstaGoriva = vrstaGoriva;
    }
}
