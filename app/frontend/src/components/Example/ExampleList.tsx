import { Example } from "./Example";

import styles from "./Example.module.css";

export type ExampleModel = {
    text: string;
    value: string;
};

const EXAMPLES: ExampleModel[] = [
    {
        text: "Vad är syftet med de nationella riktlinjerna som fastställts av Socialstyrelsen?",
        value: "Vad är syftet med de nationella riktlinjerna som fastställts av Socialstyrelsen?"
    },
    { text: "Hur bidrar de nationella riktlinjerna till förbättring av vårdkvalitet och patientsäkerhet i Sverige?",
      value: "Hur bidrar de nationella riktlinjerna till förbättring av vårdkvalitet och patientsäkerhet i Sverige?" 
    },
    { text: "Kan du ge exempel på ett specifikt område inom hälso- och sjukvård som omfattas av de nationella riktlinjerna?",
      value: "Kan du ge exempel på ett specifikt område inom hälso- och sjukvård som omfattas av de nationella riktlinjerna?" 
    },
    { text: "Hur utvecklas och uppdateras de nationella riktlinjerna för att säkerställa att de förblir relevanta och effektiva?​",
      value: "Hur utvecklas och uppdateras de nationella riktlinjerna för att säkerställa att de förblir relevanta och effektiva?​" 
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
