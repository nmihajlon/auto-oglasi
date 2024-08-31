package Models;

import jakarta.persistence.*;

import java.io.Serializable;
import java.util.Date;

@Entity
@Table(name = "oglas")
public class Oglas implements Serializable {
    private static final long serialVersionUID = 1L;

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id")
    private Integer id;

    @ManyToOne
    @JoinColumn(name = "automobil_id")
    private Automobil automobil;

    @ManyToOne
    @JoinColumn(name = "user_id")
    private User user_id;

    @Column(name = "cena", nullable = true)
    private Integer cena;
    @Column(name = "godiste", nullable = true)
    private Integer godiste;

    @Column(name = "opis", length = 2500, nullable = true)
    private String opis;

    @Column(name = "kilometraza")
    private Integer kilometraza;

    @Enumerated(EnumType.STRING)
    @Column(name = "ostecenje")
    private Ostecenja ostecenje;

    @Column(name = "registrovan_do")
    private Date registrovanDo;

    @Column(name = "boja")
    private String boja;

    @Column(name = "istaknut_oglas")
    private Boolean istaknutOglas;

    @Column(name = "zamena")
    private Boolean zamena;

    @Column(name = "kubikaza")
    private Double kubikaza;

    @Column(name = "kw")
    private Integer kw;

    @Column(name = "ks")
    private Double ks;

    public Oglas(){}

    public Oglas(Integer id, Automobil automobil, User user_id, Integer cena, Integer godiste, String opis, Integer kilometraza, Ostecenja ostecenje, Date registrovanDo, String boja, Boolean istaknutOglas, Double kubikaza, Integer kw, Double ks, Boolean zamena) {
        this.id = id;
        this.automobil = automobil;
        this.user_id = user_id;
        this.cena = cena;
        this.godiste = godiste;
        this.opis = opis;
        this.kilometraza = kilometraza;
        this.ostecenje = ostecenje;
        this.registrovanDo = registrovanDo;
        this.boja = boja;
        this.istaknutOglas = istaknutOglas;
        this.kubikaza = kubikaza;
        this.kw = kw;
        this.ks = ks;
        this.zamena = zamena;
    }

    public Integer getId() {
        return id;
    }

    public void setId(Integer id) {
        this.id = id;
    }

    public Automobil getAutomobil() {
        return automobil;
    }

    public void setAutomobil(Automobil automobil) {
        this.automobil = automobil;
    }

    public User getUser_id() {
        return user_id;
    }

    public void setUser_id(User user_id) {
        this.user_id = user_id;
    }

    public Integer getCena() {
        return cena;
    }

    public void setCena(Integer cena) {
        this.cena = cena;
    }

    public Integer getGodiste() {
        return godiste;
    }

    public void setGodiste(Integer godiste) {
        this.godiste = godiste;
    }

    public String getOpis() {
        return opis;
    }

    public void setOpis(String opis) {
        this.opis = opis;
    }

    public Integer getKilometraza() {
        return kilometraza;
    }

    public void setKilometraza(Integer kilometraza) {
        this.kilometraza = kilometraza;
    }

    public Ostecenja getOstecenje() {
        return ostecenje;
    }

    public void setOstecenje(Ostecenja ostecenje) {
        this.ostecenje = ostecenje;
    }

    public Date getRegistrovanDo() {
        return registrovanDo;
    }

    public void setRegistrovanDo(Date registrovanDo) {
        this.registrovanDo = registrovanDo;
    }

    public String getBoja() {
        return boja;
    }

    public void setBoja(String boja) {
        this.boja = boja;
    }

    public Boolean getIstaknutOglas() {
        return istaknutOglas;
    }

    public void setIstaknutOglas(Boolean istaknutOglas) {
        this.istaknutOglas = istaknutOglas;
    }

    public Double getKubikaza() {
        return kubikaza;
    }

    public void setKubikaza(Double kubikaza) {
        this.kubikaza = kubikaza;
    }

    public Integer getKw() {
        return kw;
    }

    public void setKw(Integer kw) {
        this.kw = kw;
    }

    public Double getKs() {
        return ks;
    }

    public void setKs(Double ks) {
        this.ks = ks;
    }

    public Boolean getZamena() {
        return zamena;
    }

    public void setZamena(Boolean zamena) {
        this.zamena = zamena;
    }
}