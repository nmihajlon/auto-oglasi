package Models;

import jakarta.persistence.*;

import java.io.Serializable;
import java.util.Set;

@Entity
@Table(name = "automobili")
public class Automobil implements Serializable {
    private static final long serialVersionUID = 1L;

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id")
    private Integer id;

    @Column(name = "marka")
    private String marka;

    @Column(name = "model")
    private String model;

    @Column(name = "menjac")
    private String menjac;

    @Column(name = "gorivo")
    private String gorivo;

    @Column(name = "karoserija")
    private String karoserija;

    @Column(name = "pogon")
    private String pogon;

    @Column(name = "zemlja")
    private String zemlja;


    public Automobil(){}

    public Automobil(Integer id, String marka, String model, String menjac, String gorivo, String karoserija, String pogon, String zemlja) {
        this.id = id;
        this.marka = marka;
        this.model = model;
        this.menjac = menjac;
        this.gorivo = gorivo;
        this.karoserija = karoserija;
        this.zemlja = zemlja;
        this.pogon = pogon;
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