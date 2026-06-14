export interface Blog {
    id: string;
    body: string;
    data: {
        title: string;
        description: string;
        datetime: string;
        image?: string;
        category: string;
        tags: string[];
    }
}
