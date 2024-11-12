#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#define MAX_STATE_LENGTH 50
#define MAX_SYMBOL_LENGTH 10
#define MAX_TRANSITIONS 100
#define MAX_STATES 50
#define MAX_ALPHABET 26


typedef struct {
    char from_state[MAX_STATE_LENGTH];
    char symbol[MAX_SYMBOL_LENGTH];
    char to_state[MAX_STATE_LENGTH];
} Transition;        // store a transition


void display_fa(char states[][MAX_STATE_LENGTH], int num_states, char alphabet[][MAX_SYMBOL_LENGTH], int num_symbols, Transition transitions[], int num_transitions, char start_state[MAX_STATE_LENGTH], char final_states[][MAX_STATE_LENGTH], int num_final_states) {
    printf("States: ");
    for (int i = 0; i < num_states; i++) {
        printf("%s ", states[i]);
    }
    printf("\n");

    printf("Alphabet: ");
    for (int i = 0; i < num_symbols; i++) {
        printf("%s ", alphabet[i]);
    }
    printf("\n");

    printf("Transitions:\n");
    for (int i = 0; i < num_transitions; i++) {
        printf("%s --%s--> %s\n", transitions[i].from_state, transitions[i].symbol, transitions[i].to_state);
    }  // display the states, alphabet, transitions, and final states

    printf("Start State: %s\n", start_state);

    printf("Final States: ");
    for (int i = 0; i < num_final_states; i++) {
        printf("%s ", final_states[i]);
    }
    printf("\n");
}

int main() {
    FILE *file = fopen("fa.in.txt", "r");
    if (file == NULL) {
        printf("Error opening file\n");
        return 1;
    }

    // variables for storing FA components
    char states[MAX_STATES][MAX_STATE_LENGTH];
    int num_states = 0;
    char alphabet[MAX_ALPHABET][MAX_SYMBOL_LENGTH];
    int num_symbols = 0;
    Transition transitions[MAX_TRANSITIONS];
    int num_transitions = 0;
    char start_state[MAX_STATE_LENGTH];
    char final_states[MAX_STATES][MAX_STATE_LENGTH];
    int num_final_states = 0;

    char line[256];
    fgets(line, sizeof(line), file); // Read the "states:" line
    if (strncmp(line, "states:", 7) == 0) {
        char *token = strtok(line + 8, " \n");
        while (token != NULL) {
            strcpy(states[num_states++], token);
            token = strtok(NULL, " \n");
        }
    }

    fgets(line, sizeof(line), file); // Read the "alphabet:" line
    if (strncmp(line, "alphabet:", 9) == 0) {
        char *token = strtok(line + 10, " \n");
        while (token != NULL) {
            strcpy(alphabet[num_symbols++], token);
            token = strtok(NULL, " \n");
        }
    }

    fgets(line, sizeof(line), file); // Read the "transitions:" line
    fgets(line, sizeof(line), file); // Skip the blank line or the next line with transitions
    while (fgets(line, sizeof(line), file) && line[0] != '\n') {
        // Check for a transition
        if (strchr(line, '(')) {
            continue;  // Ignore transitions with "(no transition)"
        }

        Transition t;
        if (sscanf(line, "%s %s %s", t.from_state, t.symbol, t.to_state) == 3) {
            transitions[num_transitions++] = t;
        }
    }

    fgets(line, sizeof(line), file); // Read the "start_state:" line
    if (strncmp(line, "start_state:", 12) == 0) {
        sscanf(line + 13, "%s", start_state);
    }

    fgets(line, sizeof(line), file); // Read the "final_states:" line
    if (strncmp(line, "final_states:", 13) == 0) {
        char *token = strtok(line + 14, " \n");
        while (token != NULL) {
            strcpy(final_states[num_final_states++], token);
            token = strtok(NULL, " \n");
        }
    }

    fclose(file);

    display_fa(states, num_states, alphabet, num_symbols, transitions, num_transitions, start_state, final_states, num_final_states);

    return 0;
}
