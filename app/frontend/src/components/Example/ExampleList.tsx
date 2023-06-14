import { Example } from "./Example";

import styles from "./Example.module.css";

export type ExampleModel = {
    text: string;
    value: string;
};

const EXAMPLES: ExampleModel[] = [
    {
        text: "Vad är det primära syftet med de Nationella riktlinjer som fastställts av Socialstyrelsen?",
        value: "Vad är det primära syftet med de Nationella riktlinjer som fastställts av Socialstyrelsen?"
    },
    { text: "Hur bidrar Nationella riktlinjer till förbättring av vårdkvalitet och patientsäkerhet i Sverige?",
      value: "Hur bidrar Nationella riktlinjer till förbättring av vårdkvalitet och patientsäkerhet i Sverige?" 
    },
    { text: "Kan du ge ett exempel på ett specifikt område inom hälso- och sjukvård som omfattas av Nationella riktlinjer?",
      value: "Kan du ge ett exempel på ett specifikt område inom hälso- och sjukvård som omfattas av Nationella riktlinjer?" 
    },
    { text: "Hur utvecklas och uppdateras Nationella riktlinjer för att säkerställa att de förblir relevanta och effektiva?",
      value: "Hur utvecklas och uppdateras Nationella riktlinjer för att säkerställa att de förblir relevanta och effektiva?" 
    },
    { text: "Vilken roll spelar vårdprofessionella och organisationer i genomförandet av Nationella riktlinjer?",
      value: "Vilken roll spelar vårdprofessionella och organisationer i genomförandet av Nationella riktlinjer?" 
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
