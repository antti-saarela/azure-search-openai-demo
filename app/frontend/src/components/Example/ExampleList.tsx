import { Example } from "./Example";

import styles from "./Example.module.css";

export type ExampleModel = {
    text: string;
    value: string;
};

const EXAMPLES: ExampleModel[] = [
    {
        text: "Mikä on Lewyn-kappaleen tauti?",
        value: "Mikä on Lewyn-kappaleen tauti?"
    },
    { text: "Kerro minulle anemiasta lapsilla",
      value: "Kerro minulle anemiasta lapsilla" 
    },
    { text: "Mikä on meningiitti?",
      value: "Mikä on meningiitti?" 
    },
    { text: "Mitä  ovat KLL ja KML?",
      value: "Mitä  ovat KLL ja KML?" 
    },
    { text: "Berätta för mig om anafylaktisk reaktion",
      value: "Berätta för mig om anafylaktisk reaktion" 
    },
    { text: "Mistä tunnnistaa vaskulaarisen kognitiivisen heikentymän?",
      value: "Mistä tunnnistaa vaskulaarisen kognitiivisen heikentymän?" 
    },
];

interface Props {
    onExampleClicked: (value: string) => void;
}

export const ExampleList = ({ onExampleClicked }: Props) => {
    return (
        <ul className={styles.examplesNavList}>
            {EXAMPLES.map((x, i) => (
                <li key={i}>
                    <Example text={x.text} value={x.value} onClick={onExampleClicked} />
                </li>
            ))}
        </ul>
    );
};
