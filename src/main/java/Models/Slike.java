package Models;

import jakarta.persistence.*;

@Entity
@Table(name = "slike_oglasa")
public class Slike {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id")
    private Integer id;

    @ManyToOne
    @JoinColumn(name = "id_oglasa")
    private Oglas oglas;

    @Column(name = "slika")
    private String slika;

    public Slike(){}

    public Slike(Integer id, Oglas oglas, String slika) {
        this.id = id;
        this.oglas = oglas;
        this.slika = slika;
    }

    public Integer getId() {
        return id;
    }

    public void setId(Integer id) {
        this.id = id;
    }

    public Oglas getOglas() {
        return oglas;
    }

    public void setOglas(Oglas oglas) {
        this.oglas = oglas;
    }

    public String getSlika() {
        return slika;
    }

    public void setSlika(String slika) {
        this.slika = slika;
    }
}